-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMINAEMPLEADOSCON`;
DELIMITER $$


CREATE PROCEDURE `NOMINAEMPLEADOSCON`(
	Par_InstitNominaID			INT(11),			-- Parametro que solicita el ID del instituto de nomina
	Par_ClienteID				INT(11),			-- Parametro que solicita el ID del cliente
    Par_ProspectoID				BIGINT(20),			-- Parametro que solicita el ID del prospecto
	Par_NominaEmpID				INT(11),			-- Identificador del empleado de Nomina
	Par_ConvNominaID			BIGINT UNSIGNED,	-- Identificador del convenio de Nomina

    Par_SaldoMinimo				DECIMAL(14,2),		-- Parametro que solicita el Saldo Minimo
	Par_NumCon					TINYINT UNSIGNED,	-- Parametro que solicita el numero de consulta
	Par_EmpresaID				INT(11),			-- Parametros de auditoria
	Aud_Usuario					INT(11),			-- Parametros de auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de auditoria

	Aud_DireccionIP				VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal				INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de auditoria
	)

TerminaStore: BEGIN


DECLARE Var_ClienteID     	INT(11);
DECLARE NumErr      		INT(11);
DECLARE ErrMen      		VARCHAR(80);

DECLARE	Con_Estatus	    	INT(11);
DECLARE	Con_EstatusEN		INT(11);
DECLARE	Con_ConEmpleado		INT(11);	-- Consulta de empleados de nomina para la pantalla de relacion de clientes con empresas de nomina
DECLARE	Con_ClienteRelaNom	INT(11);	-- Consulta de empleados de nomina para la pantalla alta de solicitud
DECLARE	Con_Cliente			INT(11);	-- Consulta de empleado de nomina de un instituto de nomina relacionado al cliente
DECLARE	Con_EmpBaja			INT(11);	-- Consulta de empleados baja


DECLARE	Cadena_Vacia    	CHAR(1);
DECLARE	Entero_Cero			INT(11);


SET	Con_Estatus	 	 		:= 1;
SET	Con_EstatusEN			:= 2;
SET Con_ConEmpleado	 		:= 3;	-- Consulta de empleados de nomina para la pantalla de relacion de clientes con empresas de nomina
SET Con_ClienteRelaNom 		:= 4;	-- Consulta de empleados de nomina para la pantalla alta de solicitud
SET Con_Cliente 			:= 5;	-- Consulta de empleados de nomina para la pantalla alta de solicitud
SET Con_EmpBaja 			:= 6;	-- Consulta de empleados baja
SET	Cadena_Vacia 	 		:= '';
SET	Entero_Cero	 	 		:= 0;

SET Par_ClienteID   		:= IFNULL(Par_ClienteID, Entero_Cero);
SET Par_ProspectoID  		:= IFNULL(Par_ProspectoID, Entero_Cero);


	-- Consulta 1
	if(Par_NumCon = Con_Estatus) then
	 Set Var_ClienteID := (select ClienteID
						   from NOMINAEMPLEADOS
						   where ClienteID = Par_ClienteID
						   and InstitNominaID=Par_InstitNominaID);
		if(ifnull(Var_ClienteID, Entero_Cero))= Entero_Cero then
				set 	NumErr := 1;
				set 	ErrMen := 'El Cliente no existe o no corresponde a la Institución';
					select 	Cadena_Vacia as NombreCompleto, Cadena_Vacia as Estatus, 	Cadena_Vacia as FechaInicialInc,Cadena_Vacia as FechaFinInc,
							Cadena_Vacia as FechaBaja,		Cadena_Vacia as MotivoBaja,	NumErr, 	ErrMen;
		else
			set 	NumErr := 0;
			 set 	ErrMen := 'Consulta Exitosa';
				select 	cli.NombreCompleto, ne.Estatus, ne.FechaInicioInca, ne.FechaFinInca,
						  ne.FechaBaja,      ifnull(MotivoBaja,Cadena_Vacia),	NumErr, 			ErrMen
				from     NOMINAEMPLEADOS	 ne
				inner join CLIENTES cli
				on ne.ClienteID= cli.ClienteID
				where  cli.ClienteID=Par_ClienteID
				and ne.InstitNominaID = Par_InstitNominaID;
	   end if;
	end if;

	-- Consulta 2
	if(Par_NumCon = Con_EstatusEN) then
		select 	Cli.NombreCompleto, Nom.Estatus, Nom.FechaInicioInca, Nom.FechaFinInca,
				Nom.FechaBaja,     ifnull(MotivoBaja,Cadena_Vacia) as MotivoBaja
		from NOMINAEMPLEADOS Nom
		inner join CLIENTES Cli
		on Nom.ClienteID = Cli.ClienteID
		where  Cli.ClienteID = Par_ClienteID
		and Nom.InstitNominaID = Par_InstitNominaID;
	 end if;

 -- Consulta 3
	IF(Par_NumCon = Con_ConEmpleado) THEN
		SELECT	nomemp.NominaEmpleadoID,	nomemp.InstitNominaID,		instit.NombreInstit,	nomemp.ClienteID,		cli.NombreCompleto,
				nomemp.ConvenioNominaID,	nomemp.TipoEmpleadoID,		nomemp.TipoPuestoID,	nomemp.NoEmpleado,		nomemp.Estatus,
                nomemp.QuinquenioID,		nomemp.CentroAdscripcion,
                CASE WHEN  nomemp.FechaIngreso!='1900-01-01' THEN nomemp.FechaIngreso ELSE "" END AS FechaIngreso,
				nomemp.NoPension
			FROM NOMINAEMPLEADOS AS nomemp
				INNER JOIN INSTITNOMINA AS instit ON nomemp.InstitNominaID = instit.InstitNominaID
				INNER JOIN CLIENTES AS cli ON nomemp.ClienteID = cli.ClienteID
			WHERE	nomemp.ClienteID		= Par_ClienteID
			  AND	nomemp.NominaEmpleadoID	= Par_NominaEmpID;
	END IF;

    -- Consulta 4
    IF(Par_NumCon = Con_ClienteRelaNom) THEN
		SELECT 	Nom.NominaEmpleadoID, 		Nom.InstitNominaID, 		Nom.ConvenioNominaID, 		Nom.TipoEmpleadoID, 		Nom.TipoPuestoID,
				Nom.NoEmpleado
		FROM NOMINAEMPLEADOS Nom
		INNER JOIN CLIENTES Cli ON Nom.ClienteID = Cli.ClienteID
		WHERE  Cli.ClienteID = Par_ClienteID
        LIMIT 1;
	 END IF;

	-- Consulta 5
	IF (Par_NumCon = Con_Cliente) THEN
		SELECT	NominaEmpleadoID, 		InstitNominaID,			ConvenioNominaID,				ClienteID,			TipoEmpleadoID,
				TipoPuestoID,			NoEmpleado,				Estatus
			FROM NOMINAEMPLEADOS
			WHERE ClienteID 		= Par_ClienteID
			AND InstitNominaID		= Par_InstitNominaID
			AND ConvenioNominaID 	= Par_ConvNominaID;
	END IF;

    -- Consulta 6
    IF (Par_NumCon = Con_EmpBaja) THEN
		SELECT	nomemp.NominaEmpleadoID,	nomemp.InstitNominaID,	nomemp.ClienteID,	cli.NombreCompleto,	nomemp.ConvenioNominaID,
				nomemp.NoEmpleado,
				CASE nomemp.Estatus
					WHEN EstatusActivo THEN 'ACTIVO'
					WHEN Con_EstatusI THEN 'INCAPACIDAD'
					WHEN Con_EstatusP THEN 'PERMISO'
				END AS Estatus
			FROM NOMINAEMPLEADOS AS nomemp
			INNER JOIN CLIENTES AS cli ON nomemp.ClienteID = cli.ClienteID
			WHERE	nomemp.InstitNominaID	= Par_InstitNominaID
			  AND	nomemp.ConvenioNominaID	= Par_ConvNominaID
			  AND	nomemp.ClienteID		= Par_ClienteID
			  AND	nomemp.Estatus			IN (EstatusActivo, Con_EstatusI, Con_EstatusP);
	END IF;

END TerminaStore$$