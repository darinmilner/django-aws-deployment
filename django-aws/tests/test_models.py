import pytest 

pytestmark = pytest.mark.django_db

class TestProfileModel:
    def test_str_return(self, profile_factory):
        profile = profile_factory(about_me="about me")
        assert profile.__str__() == "Profile for user about me"