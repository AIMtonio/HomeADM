-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMINAEMPLEADOSLIS`;
DELIMITER $$


CREATE PROCEDURE `NOMINAEMPLEADOSLIS`(
	Par_Nombre					VARCHAR(200),		-- Parametro que solcita el nombre del cliente
	Par_InstitucionID			INT(11),			-- Parametro que solicita el ID de la institucion nomina
    Par_ClienteID				INT(11),			-- Identificador del cliente
	Par_SaldoMinimo				DECIMAL(14,2),		-- Parametro que solicita el Saldo Minimo
	Par_ConvenioNominaID 		BIGINT UNSIGNED,	-- ID del Convenio Nomina
	Par_TipoCuentaID			INT(11),			-- Tipo de cuenta de ahorro
    Par_TipoLis					INT(11),			-- Tipo de lista a ejecutar

	Aud_EmpresaID				INT(11),			-- Parametros de auditoria
	Aud_Usuario					INT(11),			-- Parametros de auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal				INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de auditoria
	)

TerminaStore: BEGIN


DECLARE Lis_EmpleadoWS   	int;
DECLARE Lis_EmpleadoIN   	int;
DECLARE Lis_LisAyuda		INT(11);	-- Lista de ayuda de empleados con base en el cliente y el nombre de la empresa de nomina
DECLARE	Lis_ConBajInc		INT(11);	-- Consulta de empleados de nomina para la pantalla de Administracion de Clientes de Nomina (Bajas e Incapacidades)
DECLARE EstatusActivo   	char(1);


Set Lis_EmpleadoWS			:= 1;
Set Lis_EmpleadoIN			:= 2;
SET Lis_LisAyuda			:= 3;				-- Lista de ayuda de empleados con base en el cliente y el nombre de la empresa de nomina
SET Lis_ConBajInc	 		:= 4;				-- Consulta de empleados de nomina para la pantalla de Administracion de Clientes de Nomina (Bajas e Incapacidades)
Set EstatusActivo			:='A';


	if(Par_TipoLis = Lis_EmpleadoWS)then

		select Ne.ClienteID, Cli.NombreCompleto
		from NOMINAEMPLEADOS Ne
		inner join CLIENTES Cli on Ne.ClienteID = Cli.ClienteID
		where Ne.InstitNominaID = Par_InstitucionID
		  and Cli.NombreCompleto like concat("%",Par_Nombre, "%")
		limit 0, 15;

	end if;

	if(Par_TipoLis = Lis_EmpleadoIN) then

	 Select	Cli.ClienteID, Cli.NombreCompleto
	 from   CLIENTES Cli inner join NOMINAEMPLEADOS Nem ON  Cli.ClienteID = Nem.ClienteID
	 where  Cli.NombreCompleto like concat("%",Par_Nombre, "%")
	 and    Nem.InstitNominaID = Par_InstitucionID
	 limit 0, 15;

	end if;

-- Lista de ayuda de empleados con base en el cliente y el nombre de la empresa de nomina
	IF (Par_TipoLis = Lis_LisAyuda) THEN
		SELECT	nomemp.NominaEmpleadoID,	nomemp.ClienteID,	instit.NombreInstit,	nomemp.ConvenioNominaID,	nomemp.NoEmpleado
			FROM NOMINAEMPLEADOS AS nomemp
			INNER JOIN INSTITNOMINA AS instit ON nomemp.InstitNominaID = instit.InstitNominaID
			WHERE	nomemp.ClienteID	= Par_ClienteID
			AND	instit.NombreInstit LIKE CONCAT('%', Par_Nombre, '%')
			LIMIT 0, 15;
	END IF;

	-- Consulta de empleados de nomina para la pantalla de Administracion de Clientes de Nomina (Bajas e Incapacidades)
	IF (Par_TipoLis = Lis_ConBajInc) THEN
		SELECT 	NOM.NominaEmpleadoID, 		NOM.InstitNominaID,							INST.NombreInstit, 			NOM.ClienteID,			 			NOM.ConvenioNominaID,
				NOM.TipoEmpleadoID,			CAT.Descripcion AS DescTipoEmpleado,	 	NOM.TipoPuestoID, 			TIP.Descripcion AS DescTipoPuesto, 	NOM.NoEmpleado,
                CASE NOM.Estatus WHEN 'A' THEN "ACTIVO" WHEN 'I' THEN "INCAPACIDAD" WHEN "B" THEN "BAJA" ELSE "" END AS Estatus,						TIP.Descripcion AS DesPuestoOcupacion
			FROM NOMINAEMPLEADOS NOM
			INNER JOIN INSTITNOMINA INST ON NOM.InstitNominaID = INST.InstitNominaID
			INNER JOIN TIPOSPUESTOS TIP ON NOM.TipoPuestoID = TIP.TipoPuestoID
            INNER JOIN CATTIPOEMPLEADOS CAT ON CAT.TipoEmpleadoID = NOM.TipoEmpleadoID
            WHERE NOM.ClienteID = Par_ClienteID
			ORDER BY INST.NombreInstit;

	END IF;
END TerminaStore$$