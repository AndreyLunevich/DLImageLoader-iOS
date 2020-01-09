public enum CacheStrategy {

    case original(key: String?)
    case tranformed(key: String?)
    case both(original: String?, tranformed: String?)
}
