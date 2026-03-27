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
    # all parameter allows non-running containers in results
    assert (
        len(dockerc.compose.ps(all=True)) == 1
    ), "Wrong number of containers were started."


def test_wait_for_ready(main_container):
    """Wait for container to be ready."""
    timeout = 10
    for _i in range(timeout):
        if READY_MESSAGE in main_container.logs():
            break
        time.sleep(1)
    else:
        raise Exception(
            f"Container does not seem ready.  "
            f'Expected "{READY_MESSAGE}" in the log within {timeout} seconds.'
        )


# GoPhish never exits
# def test_wait_for_exits(dockerc, main_container, version_container):
#     """Wait for containers to exit."""
#     assert (
#         dockerc.wait(main_container.id) == 0
#     ), "Container service (main) did not exit cleanly"
#     assert (
#         dockerc.wait(version_container.id) == 0
#     ), "Container service (version) did not exit cleanly"


# def test_output(dockerc, main_container):
#     """Verify the container had the correct output."""
#     # make sure container exited if running test isolated
#     dockerc.wait(main_container.id)
#     log_output = main_container.logs()
#     assert DIVISION_MESSAGE in log_output, "Division message not found in log output."
#     assert SECRET_QUOTE in log_output, "Secret not found in log output."


@pytest.mark.skipif(
    RELEASE_TAG in [None, ""], reason="this is not a release (RELEASE_TAG not set)"
)
def test_release_version(project_version):
    """Verify that release tag version agrees with the module version."""
    assert (
        RELEASE_TAG == f"v{project_version}"
    ), "RELEASE_TAG does not match the project version"


# GoPhish doesn't print the version to the logs
# def test_log_version(dockerc, project_version, version_container):
#     """Verify the container outputs the correct version to the logs."""
#     # make sure container exited if running test isolated
#     dockerc.wait(version_container.id)
#     log_version = semver.version.Version.parse(version_container.logs().strip())
#     assert log_version == semver.version.Version.parse(project_version), (
#         "Container version output to log does not match project version file "
#         f"{VERSION_FILE}"
#     )


@pytest.mark.skipif(
    RELEASE_TAG in [None, ""], reason="this is not a release (RELEASE_TAG not set)"
)
def test_container_version_label_matches(project_version, main_container):
    """Verify the container version label is the correct version."""
    assert (
        main_container.config.labels["org.opencontainers.image.version"]
        == project_version
    ), "Dockerfile version label does not match project version"
