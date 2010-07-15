<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE sqlMap PUBLIC "-//ibatis.apache.org//DTD SQL Map 2.0//EN" 
    "http://ibatis.apache.org/dtd/sql-map-2.dtd">
    
<#macro namespace>${tableConfig.tableClassName}.</#macro>

<sqlMap>

<#list tableConfig.sqls as sql>	
<#if sql.selectSql>
	<#if (sql.columnsCount > 1 && !sql.columnsInSameTable)>
	<resultMap id="RM-${sql.resultClassName}" class="${sql.resultClass}">
    	<#list sql.columns as column>
		<result property="${column.columnNameFirstLower}" column="${column.sqlName}"/>
    	</#list>
	</resultMap>
	</#if>
		
	<select id="<@namespace/>${sql.operation}" resultMap="<#if sql.columnsCount == 1>${sql.resultClassName}<#else>RM.${sql.resultClassName}</#if>" >
    	<![CDATA[
    	<@genPageQueryStart sql/>
    	${sql.ibatisSql}
    	<@genPageQueryEnd sql/>
    	]]>
	</select>	
    
</#if>
	
<#if sql.updateSql>
	<update id="UserInfo.update">
    	<![CDATA[
		${sql.ibatisSql}
    	]]>
	</update>
</#if>
	
<#if sql.deleteSql>
	<delete id="UserInfo.delete">
    	<![CDATA[
		${sql.ibatisSql}
    	]]>
    </delete>
</#if>
    
<#if sql.insertSql>
	<insert id="UserInfo.insert">
    	<![CDATA[
		${sql.ibatisSql}
    	]]>
        <#if database_type == 'oracle'>
		<selectKey resultClass="java.lang.Long" type="pre" keyProperty="${tableConfig.dummypk}" >
            SELECT  ${tableConfig.sequence}.nextval AS ID FROM DUAL
        </selectKey>         
        </#if>
        <#if database_type == 'mysql'>
		<selectKey resultClass="java.lang.Long" type="post" keyProperty="${tableConfig.dummypk}" >
            select last_insert_id()
        </selectKey>        
        </#if> 
        <#if database_type == 'sqlserver'>
		<selectKey resultClass="java.lang.Long" type="post" keyProperty="${tableConfig.dummypk}" >
            SELECT  @@identity  AS  ID
        </selectKey>        
        </#if>                     
	</insert>
</#if>
</#list>

</sqlMap>

<#macro genPageQueryStart sql>
	<#if sql.paging>
		<#if database_type == 'oracle'>
		select * from ( select row_.*, rownum rownum_ from (
		</#if>
	</#if>
</#macro>
<#macro genPageQueryEnd sql>
	<#if sql.paging>
		<#if database_type == 'oracle'>
		) row_ ) where rownum_ <= #endRow# and rownum_ > #startRow#
		</#if>
		<#if database_type == 'mysql'>
		limit #offset#,#limit#
		</#if>
		<#if database_type == 'postgre_sql'>
		offset #offset# limit #limit#
		</#if>		
	</#if>
</#macro>