/*
A web worker that expects a list whose first element is a string, and any
further elements are considered arguments to a function f (this function is
obtained from evaluating the initial string). the result is relayed back to the
parent process (or, this script runs forever...)
*/
onmessage = (e) => {
    console.log("Worker: Message received from main script");

    const result = e.data[0] * e.data[1];

    if (isNaN(result)) {
        postMessage("Please write two numbers");
    } else {
        const workerResult = "Result: " + result;
        console.log("Worker: Posting message back to main script");
        postMessage(workerResult);
    }
};