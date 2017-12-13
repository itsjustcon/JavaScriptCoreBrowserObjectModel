source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

#abstract_target 'JavaScriptCoreBrowserObjectModel' do
#    pod 'Alamofire', '~> 4.6'
#
#    target 'iOS'
#    target 'macOS'
#    target 'tvOS'
#end

def shared_test_pods
    pod 'GCDWebServer', '~> 3.0'
    #pod 'Swifter', '~> 1.3' # currently macOS-only!
end
#abstract_target 'Tests' do
#    pod 'Swifter', '~> 1.3'
#
#    target 'iOS Tests'
#    target 'macOS Tests'
#    target 'tvOS Tests'
#end



#target 'iOS' do
#    platform :ios, '9.0'
#end
#target 'iOS Tests' do
#    platform :ios, '9.0'
#    shared_test_pods
#end
target 'iOS' do
    platform :ios, '9.0'

    target 'iOS Tests' do
        inherit! :search_paths
        shared_test_pods
    end
end

target 'macOS' do
    platform :osx, '10.10'

    target 'macOS Tests' do
        inherit! :search_paths
        shared_test_pods
    end
end

target 'tvOS' do
    platform :tvos, '9.0'

    target 'tvOS Tests' do
        inherit! :search_paths
        shared_test_pods
    end
end
