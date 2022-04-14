DELIMITER ;
DROP PROCEDURE IF EXISTS ESTATUSCTASANREP;

DELIMITER $$
CREATE PROCEDURE ESTATUSCTASANREP(
	-- SP PARA EL REPORTE DE DISPERSION POR ORDENES DE PAGO
	Par_FechaInicio			DATE,					-- Fecha de inicio del reporte
	Par_FechaFin			DATE,					-- Fecha de fin del reporte
	Par_SolicitudCreID		INT,					-- Solicitud de credito con forma de pago orden de pago
	Par_Estatus				CHAR(1),				-- Estaus de la orden de pago
	Par_SucursalID			INT(11),				-- Numero de la sucursal
	Par_NumReporte          TINYINT UNSIGNED,		-- Numero del reporte que se genera 1 .- Excel

	Aud_EmpresaID			INT(11),				-- Parametros de auditoria
    Aud_Usuario				INT(11),				-- Parametros de auditoria
    Aud_FechaActual			DATETIME,				-- Parametros de auditoria
    Aud_DireccionIP			VARCHAR(15),			-- Parametros de auditoria
    Aud_ProgramaID			VARCHAR(50),			-- Parametros de auditoria
    Aud_Sucursal			INT(11),				-- Parametros de auditoria
    Aud_NumTransaccion		BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de vairbles
	DECLARE Var_Sentencia	VARCHAR(1500);

	-- Declaracion de constantes
	DECLARE Con_RepExcel	TINYINT UNSIGNED;


	DECLARE Entero_Cero		TINYINT UNSIGNED;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;


	-- Seteo de valores
	SET Con_RepExcel		:= 1;

	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';


	IF Par_NumReporte = Con_RepExcel THEN
		SET Var_Sentencia:= CONCAT("SELECT CS.SolicitudCreditoID ,CR.CreditoID,CS.Titular,CS.NumeroCta,
		CASE WHEN CS.TipoCtaSAFIID = 'A' THEN 'SANTANDER'
		WHEN CS.TipoCtaSAFIID = 'O' THEN 'OTROS BANCOS' END ExternaInterna,
		CASE WHEN CS.Estatus = 'E' THEN 'ENVIADA'
		WHEN CS.Estatus = 'A' THEN 'AUTORIZADO'
		WHEN CS.Estatus = 'C' THEN 'CANCELADO'
		WHEN CS.Estatus = 'J' THEN 'EJECUTADO'
		WHEN CS.Estatus = 'N' THEN 'EN PROCESO'
		WHEN CS.Estatus = 'P' THEN 'PENDIENTE POR AUTORIZAR'
		WHEN CS.Estatus = 'D' THEN 'PENDIENTE POR ACTIVAR'
		WHEN CS.Estatus = 'R' THEN 'RECHAZADO'
		END Estatus
		FROM CUENTASSANTANDER CS
		INNER JOIN SOLICITUDCREDITO SC ON CS.SolicitudCreditoID = SC.SolicitudCreditoID
		INNER JOIN CREDITOS CR ON CS.SolicitudCreditoID = CR.SolicitudCreditoID
		WHERE SC.FechaRegistro BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFin,"' ");

		IF IFNULL(Par_SolicitudCreID,Entero_Cero) != Entero_Cero THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND SC.SolicitudCreditoID = ",CONVERT(Par_SolicitudCreID,CHAR));
		END IF;

		IF IFNULL(Par_Estatus,Cadena_Vacia) != Cadena_Vacia THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND CS.Estatus = '",CONVERT(Par_Estatus,CHAR),"' ");
		END IF;

		IF IFNULL(Par_SucursalID,Entero_Cero) != Entero_Cero THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND CS.Sucursal = ",CONVERT(Par_SucursalID,CHAR));
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia," ;");

		SET @Sentencia	= (Var_Sentencia);

	   PREPARE ESTATUSCTASANREP FROM @Sentencia;
	   EXECUTE ESTATUSCTASANREP;
	   DEALLOCATE PREPARE ESTATUSCTASANREP;

	END IF;

END TerminaStore$$