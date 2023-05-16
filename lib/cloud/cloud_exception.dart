class CloudException implements Exception{}

//Users
class CannotAddCloudUserException extends CloudException{}

class CannotUpdateCloudUserUsernameException extends CloudException{}

class CannotUpdateCloudUserPresentException extends CloudException{}

class CannotShowAllUserException extends CloudException{}

class CannotFindCloudUser extends CloudException{}

//Groups
class CannotCreateGroupException extends CloudException {}

class CannotUpdateFieldException extends CloudException {}

class CannotFindGroupNameException extends CloudException {}