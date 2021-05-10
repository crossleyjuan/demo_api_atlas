The following scripts can be used to automate different actions in Atlas, like create a cluster, create a new restore job, etc.

General Steps:

All the steps below require the config file, there's a sample file provided as config.sample, you will need to rename it as "config"
and replace the variables.

# Create a new cluster

To create a new cluster you can use the "create-cluster.sh" script like this:


```bash
./create-cluster -n Cluster1 -s M10 -b -r EUROPE_WEST_3 -v 4.0
```
The above will create a new cluster using MongoDB Version 4.0 and M10 size in the region EUROPE_WEST_3 and enable the provider backup


# Modify Cluster

You can change the size or the backups in an existing cluster like this:

To change the cluster size:
```bash
./modify-cluster -n Cluster1 -s M30
```

To change the region you must include the cluster size:
```bash
./modify-cluster -n Cluster1 -s M30 -r EUROPE_WEST_2
```

To enable or disable the provider backup you pass true or false to the -b parameter:
```bash
./modify-cluster -n Cluster1 -b true
```

Any of the parameters specified in the create-cluster can be changed using modify cluster

# How to download the last backup from Atlas

Downloading the last backup requires 2 steps, the first one creates the job and then you can retrieve the backup from the available job

1. Create the restore job:

./createrestorejob

2. To download the backup file you would execute:

./downloadlastrestore

This script will get the restore jobs and check if the job already has a "deliveryUrl" if it has then it will download the backup to the current folder
 
# Delete cluster

To delete a cluster you can perform:

./delete-cluster.sh -n Cluster1

