
# Flash-Chat

a half baked whatsapp clone
uses Firebase for log in authentication and as a database to store the messages 
uses a custom xib as a template to display the messages aesthetically

## Podfile Configuration
```
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
```

