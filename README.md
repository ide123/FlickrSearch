# FlickrSearch
This project contains the Flickr Search App as specified and has the "extra" bonus capability added. 
It took longer than I thought it would because of a bug which was caused by UICollectionView requiring the custom UICollectionViewCell to have its content added as a sub-view - and because cells are dequeued 
and re-used the subview was being added multiple times - i.e. images were piling up at random!  By implementing prepareForReuse I was able to fix this. 
The App uses MVVM and Coordination pattern with Dependency Injection. There are no Storyboards. The main SearchViewController could probably be re-factored but it seems to be a View 
heavy app so the View Controller which manages the View(s) necessarily has quite a lot going on. 
Tests added are minimal but the code is easy to test thanks to Dependency injection and MVVM which separates out the responsibilities. I'm sure it could be better but its the best 
I could do in the time and my time on it was fragmented. Please let me know if you find any bugs! One last thing - it uses Swiftlint which can be onerous at times so has 
quite a few options removed. This was to avoid lots of rather unnnecessary warnings. Thanks for reading,  
Jonathan
