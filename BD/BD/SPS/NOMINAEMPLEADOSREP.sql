-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMINAEMPLEADOSREP`;
DELIMITER $$


CREATE PROCEDURE `NOMINAEMPLEADOSREP`(
	Par_InstitNominaID 		INT(11),				-- ID de empresa de nomina
	Par_ConvenioID			BIGINT UNSIGNED,		-- ID del convenio de nomina
    Par_FechaIni			DATE,					-- Fecha de Inicio
    Par_FechaFin			DATE,					-- Fecha de Fin
    Par_SucursalID			INT(11),				-- ID de la sucursal
    
    Par_ClienteID			INT(11),	-- ID del cliente de nomina
    Par_TipoReporte     	INT(11),	-- Tipo de reporte
	Par_EmpresaID			INT,		-- Parametro de auditoria 
	Aud_Usuario				INT,		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,	-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),-- Parametro de auditoria
    
	Aud_ProgramaID			VARCHAR(50),-- Parametro de auditoria
	Aud_Sucursal			INT,		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT		-- Parametro de auditoria

	)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE	nombreUsuario	VARCHAR(50);
	DECLARE Var_Sentencia 	VARCHAR(6000);
	DECLARE Var_RestringeReporte	CHAR(1);

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	FechaSist		DATE;
    DECLARE	EstatusAct		VARCHAR(20);
    DECLARE	EstatusBaj		VARCHAR(20);
	DECLARE	EstatusInc		VARCHAR(20);
    
	-- ASINACION DE CONSTANTES
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET EstatusAct		:= 'ACTIVO';
	SET EstatusBaj		:= 'BAJA';
	SET EstatusInc		:= 'INCAPACIDAD';
    
    
	SET Par_InstitNominaID	:= IFNULL(Par_InstitNominaID,0);
	SET Par_ConvenioID		:= IFNULL(Par_ConvenioID,0);
	SET Par_SucursalID		:= IFNULL(Par_SucursalID,0);

	CALL TRANSACCIONESPRO (Aud_NumTransaccion);

	SELECT	FechaSistema, RestringeReporte
		 INTO FechaSist, Var_RestringeReporte
	FROM PARAMETROSSIS LIMIT 1;

	SET Var_RestringeReporte:= IFNULL(Var_RestringeReporte,'N');

	SET Var_Sentencia :=  Cadena_Vacia;
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' SELECT  nom.InstitNominaID, instit.NombreInstit AS NombreInstNomina, nom.ConvenioNominaID, conv.Descripcion as DescripcionConvenio,');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' nom.NoEmpleado, cli.ClienteID, cli.NombreCompleto, IFNULL(cli.CURP,"") AS CURP,IFNULL(cli.RFC,"") AS RFC, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' nom.TipoEmpleadoID, tipemp.Descripcion AS DesTipoEmpleado, tippue.TipoPuestoID AS PuestoOcupacionID, tippue.Descripcion AS DesPuestoOcupacion, ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' CASE WHEN nom.Estatus="A" THEN "', EstatusAct,'" ');
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 	 WHEN nom.Estatus="B" THEN "', EstatusBaj,'" ');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' 	 WHEN nom.Estatus="I" THEN "', EstatusInc,'" ');
        SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' ELSE "" END AS Estatus,'  );
		SET Var_Sentencia := 	CONCAT(Var_Sentencia, ' nom.QuinquenioID, IFNULL(quin.Descripcion,"") AS DesQuinquenio, nom.FechaIngreso, suc.SucursalID, suc.NombreSucurs ');		
        
        SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' FROM NOMINAEMPLEADOS nom ');
        SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' INNER JOIN INSTITNOMINA instit ON nom.InstitNominaID= instit.InstitNominaID ');
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' INNER JOIN CONVENIOSNOMINA conv ON nom.ConvenioNominaID =conv.ConvenioNominaID ');
        SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' INNER JOIN CLIENTES cli ON nom.ClienteID=cli.ClienteID '); 
		SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' INNER JOIN SUCURSALES suc ON cli.SucursalOrigen=suc.SucursalID ');
        SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' INNER JOIN CATTIPOEMPLEADOS tipemp ON nom.TipoEmpleadoID=tipemp.TipoEmpleadoID ');
        SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' INNER JOIN TIPOSPUESTOS tippue ON nom.TipoPuestoID = tippue.TipoPuestoID ');
        SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' LEFT OUTER JOIN CATQUINQUENIOS quin ON nom.QuinquenioID=quin.QuinquenioID ');
        SET Var_Sentencia :=	CONCAT(Var_Sentencia,  ' WHERE nom.InstitNominaID !=', Entero_Cero);
        
		IF(Par_InstitNominaID!=0)THEN
			SET Var_Sentencia :=	CONCAT(Var_Sentencia,' AND nom.InstitNominaID=',CONVERT(Par_InstitNominaID,CHAR));
        END IF;       
       
		IF(Par_ConvenioID!=0)THEN
			SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' AND nom.ConvenioNominaID=',CONVERT(Par_ConvenioID,CHAR));
        END IF;

        IF(Par_ClienteID!=0)THEN
			SET Var_Sentencia=CONCAT(Var_Sentencia, ' AND nom.ClienteID=',CONVERT(Par_ClienteID,CHAR));
        END IF;
                
		IF(Par_SucursalID!=0) THEN
			SET Var_Sentencia :=CONCAT(Var_Sentencia, ' AND cli.SucursalOrigen=',CONVERT(Par_SucursalID,CHAR));
        END IF;
		
        SET Var_Sentencia :=	CONCAT(Var_Sentencia, ' ORDER BY suc.SucursalID, nom.InstitNominaID, nom.ConvenioNominaID; ');

		SET @Sentencia	= (Var_Sentencia);
		PREPARE STNOMIEMPLREP FROM @Sentencia;
		EXECUTE STNOMIEMPLREP;
		DEALLOCATE PREPARE STNOMIEMPLREP;


END TerminaStore$$

