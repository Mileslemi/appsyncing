// ignore_for_file: public_member_api_docs, sort_constructors_first

abstract class Result<D, S extends Exception> {
  //D is a dynamic type that can be returned, a user model, anything
  //S is a string error message
  const Result();
}

class Success<D, S extends Exception> extends Result<D, S> {
  final D returnValue;

  const Success({required this.returnValue});
}

class Failure<D, S extends Exception> extends Result<D, S> {
  final String error;
  final bool becauseSocket;
  const Failure({
    this.error = "Something went wrong.",
    this.becauseSocket = false,
  });

  @override
  String toString() => error;
}
