locals {
  tags = {
    environment = lower(var.environment)
    owner       = "devops"
    service     = "phlexrim"
    location    = lower(var.location)
    costcentre  = lower(var.cost_centre)
  }
  service_bus = flatten([
    for topic, snames in var.servicebus : [
      for sname in snames : {
        name              = topic
        subscription_name = sname
      }
    ]
  ])
  service_bus_map = {
    for subname in local.service_bus : "${subname.name}-${subname.subscription_name}" => subname
  }

  functionapp = {
    engine = {
      app_settings = {
        WEBSITE_MAX_DYNAMIC_APPLICATION_SCALE_OUT = var.max_app_scaleout
        Environment                               = var.func_Environment
        HttpTimeOut                               = "480000"
        JobConfigurationQuery                     = "SELECT JobConfiguration FROM JobsTopicSubMappings WHERE JobName=@jobName AND Environment=@environment AND JobType = 'Engine'"
        LogPath                                   = "C:\\home\\LogFiles\\Application"
        BaseDBContext                             = var.BaseDBContext
    } },
    service = {
      app_settings = {
        WEBSITE_MAX_DYNAMIC_APPLICATION_SCALE_OUT = var.max_app_scaleout
        Environment                               = var.func_Environment
        HttpTimeOut                               = "480000"
        JobConfigurationQuery                     = "SELECT JobConfiguration FROM JobsTopicSubMappings WHERE JobName=@jobName AND Environment=@environment AND JobType IN('Service', 'ScheduledReports')"
        LogPath                                   = "C:\\home\\LogFiles\\Application"
        BaseDBContext                             = var.BaseDBContext
    } },
    schedulereports = {
      app_settings = {
        WEBSITE_MAX_DYNAMIC_APPLICATION_SCALE_OUT = var.max_app_scaleout
        Environment                               = var.func_Environment
        HttpTimeOut                               = "480000"
        TimerTriggerQuery                         = "SELECT * FROM JobsTopicSubMappings WHERE JobType=@jobType AND Environment=@environment"
        LogPath                                   = "C:\\home\\LogFiles\\Application"
        BaseDBContext                             = var.BaseDBContext
    } },
    logs = {
      app_settings = {
      "NR_INSERT_KEY"                            ="none"
      "NR_ENDPOINT"                              = "https://log-api.newrelic.com/log/v1"
      "NR_MAX_RETRIES"                           = "3"
      "NR_RETRY_INTERVAL"                        = "2000"
      "NR_TAGS"                                  = "none"
    }}
  }
  function_app = { for app, settings in local.functionapp : app => settings }
}
