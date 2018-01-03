Rails.application.config.after_initialize do
    AwesomeJob.perform_later
end