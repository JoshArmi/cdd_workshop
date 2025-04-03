# Zero to Hero with Specmatic Contract Testing

## Required Dependencies

- A `docker` socket available
- `Make` installed

## Provider Contract Testing

### Step 1: Our first contract test

1. In a terminal window, run `make up` to make our REST server available on `http://localhost:3000`
2. In a separate terminal window, run `make contract-test` to run specmatic against our server
3. Review the specmatic output, which should look like the following

![First Run](images/first_run.png)

### Step 2: Adding a new route to the spec

1. Add the GET `/api/messages` route, which returns an array of `Message`
2. Run `make contract-test` again to check that your API spec now conforms to the implementation.
3. If needed, review `service_final.yaml` for an example.

![Second Run](images/second_run.png)

### Step 3: Our first examples

1. Add a GET `/api/message/<id>` route, which expects a UUID `id` parameter in the path, and returns a `Message`.
2. Run `make contract-test` and review the specmatic output.
3. Add request/response examples to make the test pass.
   1. You will need to add examples to both POST `/api/messages` and GET `/api/messages/<id>`
   2. Make sure to name all the examples the same
4. If needed, review `service_final.yaml` for an example.

### Step 4: Our first negative examples

1. Add a negative example for POST `/api/messages`.
2. Run `make contract-test` and review to ensure you're at 100% API coverage.
3. Remove the `@NotNull` decorators in `CreateMEssageRequest.java`.
4. Run `make contract-test` to show how the test failing now you're not receiving a 400 status code.
5. Add the decorators back to have the test pass again.

### Step 5: Making examples manageable

1. Add a folder called `service_examples`
2. Run `make generate-examples`
3. Remove all the examples from `service.yaml`
4. Run `make contract-test-examples`
5. Fix the broken test by ensuring the message exists for GET `/api/messages/<id>`

### Extension

1. Add a route to the API specification that isn't implemented. What result does specmatic give now?
2. Find out how specmatic understands what routes exist or don't exist on the backend
3. Implement your new route (you will need to restart the container to see the changes)

## Generative Tests

### Step 1: Generate new tests

1. Run `make generative-tests`
2. Review test failures

### Step 2: Fix defects

1. Add examples that show the same defects
2. Run `make contract-test` or `make contract-test-examples` to show that the same failing tests exist
3. Fix the backend code
4. Restart the backend container
5. Validate that the fixes work by running `make contract-test`

### Extension

1. Add a new route that has an enum field and run `make generative-tests` to see how many test cases are generated

## Consumer Contract Testing

### Step 1: Run the stub

1. Run `make stub`
2. Run `curl http://localhost:9000/api/messages` and check the response
3. Run a request against the stub server that uses the payload from your example
4. Run a request against the stub server that uses a payload not seen in your example
5. Notice how the stub will return the matching response to a request payload, and a correctly shaped response when it doesn't match
6. Shut down the stub server

### Step 2: Malformed example

1. Change a response example to not match the API specification, e.g. change the type of string field to an integer
2. Run `make stub`
3. Check the output of the stub server for any error messages
4. Send the request example, and check to see if the response matches the example or is randomly generated

### Extension

1. Run `make strict-stub`
2. Play with requests to see what how strict mode changes behaviour

## Enforcing Backwards Compatibility

### Step 1: A compatible change

1. Create a copy of your `service.yaml` called `service_v2.yaml`
2. Add an optional field to the `MessageContent` schema
3. Run `make compare` to check whether that the contracts are deemed non-backwards compatible

### Step 2: A breaking change

1. Create a copy of `service_v2.yaml` called `service_v3.yaml`
2. Make your optional field from step 1 mandatory
3. Run `make compare` to check that the contracts are deemed non-backwards compatible

### Extension:

1. Experiment to determine what rules specmatic uses to define backwards and non-backwards compatible changes for requests and responses. There are seven in total, including the two done in the steps before (adding an optional field to a request, and make an optional field mandatory on a request).
