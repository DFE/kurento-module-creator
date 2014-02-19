cpp/${remoteClass.name}.cpp
/* Autogenerated with Kurento Idl */

#include <memory>

<#list remoteClassDependencies(remoteClass) as dependency>
#include "${dependency.name}.hpp"
</#list>
#include "${remoteClass.name}.hpp"

namespace kurento {

<#if (!remoteClass.abstract) && (remoteClass.constructors[0])??>
std::shared_ptr<MediaObject> ${remoteClass.name}::Factory::createObject (const Json::Value &params) throw (JsonRpc::CallException)
{
  Json::Value aux;
  <#list remoteClass.constructors[0].params as param>
  ${getCppObjectType(param.type.name, false)} ${param.name};
  </#list>

  <#list remoteClass.constructors[0].params as param>
  <#assign json_method = "">
  <#assign type_description = "">
  if (!params.isMember ("${param.name}")) {
    <#if (param.defaultValue)??>
    /* param '${param.name}' not present, using default */
    <#if param.type.name = "String" || param.type.name = "int" || param.type.name = "boolean">
    ${param.name} = ${param.defaultValue};
    <#elseif model.complexTypes?seq_contains(param.type.type) >
      <#if param.type.type.typeFormat == "REGISTER">
    // TODO, deserialize default param value for type '${param.type}'
      <#elseif param.type.type.typeFormat == "ENUM">
    ${param.name} = std::shared_ptr<${param.type.name}> (new ${param.type.name} (${param.defaultValue}));
      <#else>
    // TODO, deserialize default param value for type '${param.type}' not expected
      </#if>
    <#else>
    // TODO, deserialize default param value for type '${param.type}'
    </#if>
    <#else>
    <#if (param.optional)>
    // Warning, optional constructor parameter '${param.name}' but not default value provided
    </#if>
    /* param '${param.name}' not present, raise exception */
    JsonRpc::CallException e (JsonRpc::ErrorCode::SERVER_ERROR_INIT,
                              "'${param.name}' parameter is requiered");
    throw e;
    </#if>
  } else {
    <#if model.remoteClasses?seq_contains(param.type.type) >
    std::shared_ptr<MediaObject> obj;

    </#if>
    aux = params["${param.name}"];
    <#if param.type.name = "String">
	  <#assign json_method = "String">
	  <#assign type_description = "string">
    <#elseif param.type.name = "int">
	  <#assign json_method = "Int">
	  <#assign type_description = "integer">
    <#elseif param.type.name = "boolean">
	  <#assign json_method = "Bool">
	  <#assign type_description = "boolean">
	<#elseif param.type.name = "double">
	  <#assign json_method = "Double">
	  <#assign type_description = "double">
	<#elseif model.complexTypes?seq_contains(param.type.type) >
	  <#assign json_method = "String">
	  <#assign type_description = "string">
	<#elseif model.remoteClasses?seq_contains(param.type.type) >
	  <#assign json_method = "String">
	  <#assign type_description = "string">
    </#if>
    <#if json_method != "" && type_description != "">

    if (!aux.is${json_method} ()) {
      /* param '${param.name}' has invalid type value, raise exception */
      JsonRpc::CallException e (JsonRpc::ErrorCode::SERVER_ERROR_INIT,
                              "'${param.name}' parameter should be a ${type_description}");
      throw e;
    }

      <#if model.complexTypes?seq_contains(param.type.type) >
        <#if param.type.type.typeFormat == "REGISTER">
    ${param.name} = std::shared_ptr<${param.type.name}> (new ${param.type.name} (aux));
        <#elseif param.type.type.typeFormat == "ENUM">
    ${param.name} = std::shared_ptr<${param.type.name}> (new ${param.type.name} (aux.as${json_method} ()));
        <#else>
    // TODO, deserialize param value for type '${param.type}' not expected
        </#if>
      <#elseif model.remoteClasses?seq_contains(param.type.type) >
    try {
      obj = ${param.type.name}::Factory::getObject (aux.as${json_method} ());
    } catch (JsonRpc::CallException &ex) {
      JsonRpc::CallException e (JsonRpc::ErrorCode::SERVER_ERROR_INIT,
                              "'${param.name}' object not found: "+ ex.getMessage());
      throw e;
    }

    ${param.name} = std::dynamic_pointer_cast<${param.type.name}> (obj);

    if (!${param.name}) {
      JsonRpc::CallException e (JsonRpc::ErrorCode::SERVER_ERROR_INIT,
                              "'${param.name}' object has a invalid type");
      throw e;
    }
      <#else>
    ${param.name} = aux.as${json_method} ();
      </#if>
    <#else>
    // TODO, deserialize param type '${param.type}'
    </#if>
  }

  </#list>
  return createObject (<#rt>
     <#lt><#list remoteClass.constructors[0].params as param><#rt>
        <#lt>${param.name}<#rt>
        <#lt><#if param_has_next>, </#if><#rt>
     <#lt></#list>);
}

${remoteClass.name}::Factory::StaticConstructor ${remoteClass.name}::Factory::staticConstructor;

${remoteClass.name}::Factory::StaticConstructor::StaticConstructor()
{
  if (objectRegistrar) {
    std::shared_ptr <Factory> factory (new ${remoteClass.name}::Factory());

    objectRegistrar->registerFactory(factory);
  }
}
</#if>

} /* kurento */
