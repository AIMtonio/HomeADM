-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDNOMINAWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDNOMINAWSCON`;
DELIMITER $$

CREATE PROCEDURE `CREDNOMINAWSCON`(
	-- Store Procedure Exclusivo de WS para consultar los Creditos de Nomina.
	Par_InstitucionID		INT(11),		-- Indica el numero de Institucion de Nomina
    Par_Estatus             CHAR(1),        -- Indica el Estatus del Credto V=Vigente B=Vencido
    Par_EstatusInstal       CHAR(1),        -- Indica el Estatus de la Instalacion I=Instalado N=No Instalado
   	Par_NumCon				INT(11),		-- Numero de Consulta


	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control				VARCHAR(15);	    -- Control a retornar en pantalla
    DECLARE Var_Institucion         INT(11);            -- ID de Institucion de Nomina
	-- Declaracion de Constantes,
	DECLARE	Entero_Cero				INT(11);			-- Constante de entero cero
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante cadena vacia
	DECLARE	SalidaSI				CHAR(1);			-- Salida Si
	DECLARE Con_Principal			INT(11);			-- Consulta Principal
	DECLARE Con_Vigente             CHAR(1);            -- Estatus Vigente 'V'
    DECLARE Con_Vencido             CHAR(1);            -- Estatus Vencido 'B'
    DECLARE Con_Instalado           CHAR(1);            -- Estatus Instalado 'I'
    DECLARE Con_NoInstalado         CHAR(1);            -- Estatus No Instalado 'N'
    DECLARE Var_Sentencia 		    VARCHAR(4000);
		DECLARE Con_Pagado              CHAR(1);            -- Estatus Pagado 'P'


	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:='';
	SET SalidaSI					:= 'S';
	SET Con_Principal				:= 1;
    SET Con_Vigente					:= 'V';
	SET Con_Vencido					:= 'B';
	SET Con_Instalado				:= 'I';
	SET Con_NoInstalado				:= 'N';
	SET Con_Pagado                  := 'P';

	IF(Par_NumCon = Con_Principal) THEN
		SET Var_Sentencia := 'SELECT CRE.CreditoID AS CreditoID,  IFNULL(NOM.NoEmpleado,0) AS EmpleadoID, IFNULL(SOL.FolioSolici, "") AS Folio, IFNULL(INST.NombreInstit,"") AS NombreInstitucion,';
		SET Var_Sentencia := CONCAT(Var_Sentencia,'IFNULL(CLI.PrimerNombre, "") AS PrimerNombre, 	IFNULL(CLI.SegundoNombre,"") AS SegundoNombre,	IFNULL(CLI.ApellidoPaterno, "") AS ApellidoPaterno, 	IFNULL(CLI.ApellidoMaterno, "") AS ApellidoMaterno,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'IFNULL(CLI.RFCOficial, "") AS RFC, IFNULL(CLI.CURP,"") AS CURP,   IFNULL(CRE.MontoCredito, 0) AS MontoDesembolso,	IFNULL(CRE.MontoCuota, 0) AS MontoCuota,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'CASE (CRE.FrecuenciaCap)
														WHEN "S" THEN "Semanal"  WHEN "C" THEN "Catorcenal" WHEN "Q" THEN "Quincenal"
														WHEN "M" THEN "Mensual"  WHEN "P" THEN "Periodo" WHEN "B" THEN "Bimestral"
														WHEN "T" THEN "Trimestral" WHEN "R" THEN "Tetramestral" WHEN "E" THEN "Semestral"
														WHEN "A" THEN "Anual" WHEN "L" THEN "Libres"
													END AS Frecuencia,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' DATEDIFF(CRE.FechaVencimien, CRE.FechaInicio) AS Plazo,	FNFECHASAMORTIZACIONES(CRE.CreditoID, "I") AS FechaInicio,    FNFECHASAMORTIZACIONES(CRE.CreditoID, "F") AS FechaVencimiento,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'CASE (CRE.Estatus)
														WHEN "V" THEN "Vigente"
														WHEN "B" THEN "Vencido"
													END AS Estatus,');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'SOL.FechaRegistro AS FechaSolCred, IFNULL(NOM.NoPension,"") AS NumPension,	CRE.ProductoCreditoID AS ProductoCreditoID,	NOM.CentroAdscripcion AS CentroAdscripcion, CON.ClaveConvenio AS ClaveCentroTrabajo ,CRE.FechTerminacion AS FechaLiquidacion ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'FROM CREDITOS CRE
														INNER JOIN SOLICITUDCREDITO SOL ON SOL.SolicitudCreditoID = CRE.SolicitudCreditoID
														INNER JOIN CONVENIOSNOMINA CON ON CON.ConvenioNominaID = SOL.ConvenioNominaID
														INNER JOIN INSTITNOMINA INST ON CON.InstitNominaID = INST.InstitNominaID

														INNER JOIN NOMINAEMPLEADOS NOM ON CON.ConvenioNominaID = NOM.ConvenioNominaID
														INNER JOIN CLIENTES CLI ON CRE.ClienteID = CLI.ClienteID
																AND CON.InstitNominaID = NOM.InstitNominaID AND NOM.ClienteID = CRE.ClienteID ');
		IF(IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia )THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,'AND CRE.Estatus = "',Par_Estatus,'" ');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia,'AND CRE.Estatus IN ("',Con_Vigente,'","',Con_Vencido,'","',Con_Pagado,'") ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE INST.InstitNominaID = ',Par_InstitucionID,' AND CRE.EstatusInstalacion ="',Par_EstatusInstal,'";');
		SET @Sentencia  = (Var_Sentencia);

		PREPARE STCREDNOMINA FROM @Sentencia;
		EXECUTE STCREDNOMINA;
		DEALLOCATE PREPARE STCREDNOMINA;
	END IF;

END TerminaStore$$