import React from "react";

const Root: React.FC<{ name: string }> = (props) => {
  return <section>{props.name} is mounted!</section>;
};

export default Root;
