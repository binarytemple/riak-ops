# Hands on with Riak - Controlling

## Start, Ping

1. Start Riak:

        riak start

2. Ping Riak:

        riak ping

3. What did the command return?

## Attach to Riak

### Attempt 1

1. Start Riak:

        riak start

2. Attach to Riak:

        riak attach

3. Press `Ctrl-c` `a` `Return`.

4. Ping Riak:

         riak ping

5. What happened?

### Attempt 2

1. Start Riak:

         riak start

2. Attach to Riak:

         riak attach

3. Press `Ctrl-c` `Ctrl-c`.

4. Ping Riak:

         riak ping

5. What happened?

## Attach Direct to Riak

### Attempt 1

1. Start Riak:

        riak start

2. Attach to Riak:

        riak attach-direct

3. Press `Ctrl-c` `a` `Return`.

4. Ping Riak:

         riak ping

5. What happened?

### Attempt 2

1. Start Riak:

         riak start

2. Attach to Riak:

         riak attach

3. Press `Ctrl-d`.

4. Ping Riak:

         riak ping

5. What happened?

## Console

1. Start Riak:

         riak start

2. Try to access the console:

         riak console

3. Stop Riak:

         riak stop

4. Try to access the console again:

         riak console

## Restart

1. Start Riak:

         riak start

2. Ping Riak:

         riak ping

3. Restart Riak:

         riak restart

4. Ping Riak:

         riak ping

## Stop

1. Start Riak:

         riak start

2. Ping Riak:

         riak ping

3. Stop Riak:

         riak stop

4. Ping Riak:

         riak ping
