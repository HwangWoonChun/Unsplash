# Unsplash

## iOS App 개발자 코딩 테스트 프로젝트

* Unsplash 의 사진 리스트를 보여주는 Sample iOS 개발
  1. Unsplash REST API(GET /photos) 를 이용하여 사진 리스트를 보여주게 개발
  2. MVVM 디자인 패턴을 사용하여 개발
  3. RxSWIFT 사용(옵션)

* Unsplash REST API 사용은 아래 참조: List photos
  * Get a single page from the list of all photos.
    * GET /photos

* Parameters
  * param Description
            
    * page
      * Page number to retrieve. (Optional; default: 1)
      
    * per_page
      * Number of items per page. (Optional; default: 10)
      
    * order_by
      * How to sort the photos. Optional. (Valid values: ​latest​, ​oldest​, p​ opular​; default: ​latest​)
