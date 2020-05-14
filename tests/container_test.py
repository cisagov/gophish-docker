#!/usr/bin/env pytest -vs
"""Tests for gophish container."""

# Standard Python Libraries
import os
import time

# Third-Party Libraries
import pytest

READY_MESSAGE = "Starting admin server"
RELEASE_TAG = os.getenv("RELEASE_TAG")
VERSION_FILE = "src/version.txt"


def test_container_count(dockerc):
    """Verify the test composition and container."""
    # stopped parameter allows non-running containers in results
    assert (
        len(dockerc.containers(stopped=True)) == 1
    ), "Wrong number of containers were started."


def test_wait_for_ready(main_container):
    """Wait for container to be ready."""
    TIMEOUT = 10
    for i in range(TIMEOUT):
        if READY_MESSAGE in main_container.logs().decode("utf-8"):
            break
        time.sleep(1)
    else:
        raise Exception(
            f"Container does not seem ready.  "
            f'Expected "{READY_MESSAGE}" in the log within {TIMEOUT} seconds.'
        )


@pytest.mark.skipif(
    RELEASE_TAG in [None, ""], reason="this is not a release (RELEASE_TAG not set)"
)
def test_release_version():
    """Verify that release tag version agrees with the module version."""
    pkg_vars = {}
    with open(VERSION_FILE) as f:
        exec(f.read(), pkg_vars)  # nosec
    project_version = pkg_vars["__version__"]
    assert (
        RELEASE_TAG == f"v{project_version}"
    ), "RELEASE_TAG does not match the project version"


def test_container_version_label_matches(main_container):
    """Verify the container version label is the correct version."""
    pkg_vars = {}
    with open(VERSION_FILE) as f:
        exec(f.read(), pkg_vars)  # nosec
    project_version = pkg_vars["__version__"]
    assert (
        main_container.labels["version"] == project_version
    ), "Dockerfile version label does not match project version"
