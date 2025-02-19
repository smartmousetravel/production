{ ... }:
{
  variable = {
    gcp_project = {
      description = "Google Cloud Platform project ID (not project number)";
      type = "string";
      default = "smartmouse-web";
    };

    gcp_location = {
      description = "Google Cloud Platform location code";
      type = "string";
      default = "us-east1-b";
    };
  };
}
