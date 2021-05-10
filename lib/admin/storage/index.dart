/// The default `Storage` service if no
/// app is provided or the `Storage` service associated with the provided
/// app.
 class Storage {
/// Optional app whose `Storage` service to
/// return. If not provided, the default `Storage` service will be returned.
app: app.App;
/// @returns A [Bucket](https://cloud.google.com/nodejs/docs/reference/storage/latest/Bucket)
/// instance as defined in the `@google-cloud/storage` package.
bucket(name?: string): Bucket;
}