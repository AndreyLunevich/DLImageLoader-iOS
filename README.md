DLImageLoader-iOS
=================

Image Loader for iOS. <br/>
This project aims to provide a reusable instrument for asynchronous image loading, caching and displaying.

![Screenshot](https://raw.githubusercontent.com/AndreyLunevich/DLImageLoader-iOS/master/dlil.png)

## Instalation

| Swift | DLImageLoader |
| ----- | ------------- |
| 5.X   | _             |
| 4.X   | 4.2.0         |
| 2.2   | 1.2.0-swift   |

[Objective-C](https://github.com/AndreyLunevich/DLImageLoader-iOS/tree/objc) - "DLImageLoader", "~> 2.2.0"

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add DLImageLoader to your project.

1. Add a pod entry for DLImageLoader to your Podfile `pod 'DLImageLoader'`
2. Install the pod(s) by running `pod install`.

## Usage

### Simple

<pre>
DLImageLoader.shared.load("image_url_here", into: "UIImageView here")
</pre>

### Complete

<pre>
DLImageLoader.shared.load(url, into: imageView) { result in
    switch result {
    case .success(let image):

    case .failure(let error):

    }
}
</pre>

### Cancel loading operations

<pre>
DLImageLoader.shared.cancelOperation(url: "image_url_here")
</pre>

<pre>
DLImageLoader.shared.cancelAllOperations()
</pre>


## Plans

Objective-C version will be fully moved to [objc](https://github.com/AndreyLunevich/DLImageLoader-iOS/tree/objc) branch

## Applications using DLImageLoader

[Share TV](https://itunes.apple.com/br/app/share-tv-rede-social-para/id1097456577?mt=8) |
[Nootri The Nutrition Manager](https://itunes.apple.com/US/app/id912109727?mt=8) |
[Plusarium](https://itunes.apple.com/us/app/plusarium/id901280642?l=ru&ls=1&mt=8) |
[Naomuseum](https://itunes.apple.com/ru/app/naomuseum/id847290457?mt=8) | [Aerobia](https://itunes.apple.com/us/app/aerobia/id566375588?mt=8) | [StreetForm](https://itunes.apple.com/us/app/easy/id874395902?ls=1&mt=8)

## License

See [LICENSE](https://github.com/AndreyLunevich/DLImageLoader-iOS/blob/master/LICENSE) for more information.