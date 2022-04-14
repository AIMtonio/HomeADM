-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGONOMINAWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGONOMINAWSCON`;
DELIMITER $$

CREATE PROCEDURE `PAGONOMINAWSCON`(
	-- Store Procedure Exclusivo de WS para consultar los Pagos de Nomina.
	Par_InstitucionID   		INT(11),			-- ID de la Institucion
    Par_CreditoID          		BIGINT(11),			-- ID del Credito
    Par_CURP               		CHAR(18),			-- CURP Clave Unica de Registro Poblacional
    Par_RFC                		CHAR(13),			-- RFC del cliente ya sea RFC como persona fisica o persona moral
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_UsuarioID				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_Sentencia 		    VARCHAR(4000);
    DECLARE Var_FechaSis            DATE;

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);			-- Constante de Entero Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante de Cadena Vacia
	DECLARE Est_Activo				CHAR(1);			-- Estatus Activo
	DECLARE Con_Principal			TINYINT UNSIGNED;	-- Consulta Principal
    DECLARE Con_Vigente             CHAR(1);            -- Estatus Vigente 'V'
    DECLARE Con_Vencido             CHAR(1);            -- Estatus Vencido 'B'
    DECLARE Con_NO                  CHAR(1);            -- Constante NO

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';
	SET Con_Principal			:= 1;
    SET Con_Vigente				:= 'V';
	SET Con_Vencido				:= 'B';
    SET Con_NO                  := 'N';

    SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		SET Var_Sentencia := ' SELECT Inst.InstitucionID, 		Inst.NombreCorto as NombreInstitucion, 			Cre.CreditoID, 		Cli.ClienteID, ';
		SET Var_Sentencia := CONCAT(Var_Sentencia,'Cli.NombreCompleto as NombreCliente,		IFNULL(Nom.NominaEmpleadoID, "") AS NominaEmpleadoID, 		Cre.MontoCuota, ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'FUNCIONEXIGIBLE(Cre.CreditoID) as MontoExigible, 	Cre.MontoCredito, ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'FUNCIONCONFINIQCRE(Cre.CreditoID) as SaldoCredito, ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'FUNCIONDIASATRASO(Cre.CreditoID,"',Var_FechaSis,'") AS DiasAtraso, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'FNFECHAPROXPAG(Cre.CreditoID) as FechaExigible, ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'Cre.FechaInicio,	  IFNULL(Cre.FolioInstalacion,"") AS FolioInstalacion, 	IFNULL(Cli.TelefonoCelular,"") as TelCelular, IFNULL(Cli.Telefono ,"" ) as TelParticular ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'FROM CREDITOS Cre ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'    INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cre.ClienteID ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'    INNER JOIN INSTITUCIONES Inst ON Inst.InstitucionID = Cre.InstitNominaID ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'    INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = Cre.ConvenioNominaID AND Con.InstitNominaID  = Inst.InstitucionID ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'    INNER JOIN NOMINAEMPLEADOS Nom ON Nom.InstitNominaID = Inst.InstitucionID AND Nom.ClienteID = Cli.ClienteID ');
        SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE Cre.Estatus IN ("',Con_Vigente,'","',Con_Vencido,'")');

        IF(IFNULL(Par_CreditoID,Entero_Cero) != Entero_Cero )THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'AND Cre.CreditoID = "',Par_CreditoID,'" ');
		END IF;

        IF(IFNULL(Par_CURP,Entero_Cero) != Entero_Cero )THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'AND Cli.CURP = "',Par_CURP,'" ');
		END IF;

        IF(IFNULL(Par_RFC,Entero_Cero) != Entero_Cero )THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'AND Cli.RFCOficial = "',Par_RFC,'" ');
		END IF;

        SET Var_Sentencia := CONCAT(Var_Sentencia,'    AND Con.DomiciliacionPagos  = "',Con_NO,'" AND Cre.GrupoID = "',Entero_Cero,'"; ');

        SET @Sentencia  = (Var_Sentencia);

		PREPARE WSCONCREDNOMINA FROM @Sentencia;
		EXECUTE WSCONCREDNOMINA;
		DEALLOCATE PREPARE WSCONCREDNOMINA;

	END IF;

END TerminaStore$$