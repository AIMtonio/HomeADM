-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCILIAMOVSCORRESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCILIAMOVSCORRESCON`;DELIMITER $$

CREATE PROCEDURE `CONCILIAMOVSCORRESCON`(
	# =====================================================================================
	# ----- STORED QUE LISTA LOS MOVIMIENTOS PARA PAGO DE CORRESPONSALES -------
	# =====================================================================================

	Par_NumCon 			TINYINT UNSIGNED,		-- Numero de consulta

	-- Parametros de Auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
)
TerminaStore:BEGIN

	-- Declaracion de costantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero				INT(11);		-- Entero cero

	DECLARE CompraNormal			CHAR(2);		-- Compra normal
	DECLARE CompraRetiro			CHAR(2);		-- Compra retiro
	DECLARE CompraTpoAire			CHAR(2);		-- Compra tiempo aire
	DECLARE	AjusteCompra			CHAR(2);		-- Ajuste de cuenta
	DECLARE Devolucion				CHAR(2);		-- Devolucion

	DECLARE DescCompraNor			VARCHAR(30);		-- Descripcion compra normal
	DECLARE DescComRet				VARCHAR(30);		-- Descripcion compra retiro
	DECLARE DescComTpoAire			VARCHAR(30);		-- Descripcion compra de tiempo aire
	DECLARE DescAjusteCompra		VARCHAR(30);		-- Descripcion ajuste de cuenta
	DECLARE DescDevolucion			VARCHAR(30);		-- Descripcion devolucion

	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Est_NoConc				CHAR(1);		-- Estado No concilia
	DECLARE Est_Concilia			CHAR(1);		-- Estado Concilia
	DECLARE Var_ConciliaID			INT(11);		-- Variable ID concilia
	DECLARE Var_DetalleID			INT(11);		-- Variable ID detalle

	DECLARE Var_NumCuenta			CHAR(16);		-- Variable numero de cuenta
	DECLARE Var_FechaConsumo 		DATE;			-- Variable fecha de consumo
	DECLARE Var_FechaProceso 		DATE;			-- Variable fecha de proceso
	DECLARE Var_TipoTransaccion 	CHAR(2);		-- Variable tipo de transaccion
	DECLARE Var_ImporteOrigenTrans	DECIMAL(12,2);	-- Variable importe origen de transaccion

	DECLARE Var_NumAutorizacion		CHAR(6);		-- Variable numero de autorizacion
	DECLARE Var_EstatusConci		CHAR(1);		-- Variable estado de conciliacion
	DECLARE Est_Procesado			CHAR(1);		-- Estado Procesado
	DECLARE Tipo_SAFI				VARCHAR(20);	--
	DECLARE Abono_EnLinea			INT(11);		-- Transaccion en Linea OXXO

	DECLARE Abono_Archivo			INT(11);		-- Archivo Batch 510 (WALMART y SORIANA)
	DECLARE Desc_Corresp			VARCHAR(50);	-- Descripsion correspon

	DECLARE Con_Principal 			INT(11);		-- Numero de consulta


	DECLARE CursorMov CURSOR FOR
		SELECT
			ConciliaID, 		DetalleID, 			NumCuenta, 			FechaConsumo,	FechaProceso,
			TipoTransaccion,	ImporteOrigenTrans, NumAutorizacion, 	EstatusConci
			FROM TARDEBTMPMOVS
			WHERE EstatusConci = Est_NoConc;

	-- Asignacion de Constantes
	SET CompraNormal	:= '00';						-- Compra Normal POS
	SET CompraRetiro	:= '09';						-- Compra POS + Retiro
	SET CompraTpoAire	:= '10';						-- Compra de Tiempo Aire
	SET AjusteCompra	:= '02';						-- Ajuste de Compra
	SET Devolucion		:= '20';						-- Devolucion

	SET	Cadena_Vacia	:= '';							-- Cadena vacia
	SET Entero_Cero		:= 0;							-- Entero cero
	SET Fecha_Vacia		:= '1900-01-01';				-- Fecha vacia
	SET Est_NoConc		:= 'N';							-- Estado No concilia
	SET Est_Concilia	:= 'C';							-- Estado Concilia
	SET Est_Procesado	:= 'P';							-- Estado Procesado

	SET DescCompraNor	:= 'COMPRA POS';				-- Descripcion COMPRA POS
	SET DescComRet		:= 'RETIRO EN COMPRA POS';		-- Descripcion RETIRO EN COMPRA POS
	SET DescComTpoAire	:= 'COMPRA DE TIEMPO AIRE ATM';	-- Descripcion COMPRA DE TIEMPO AIRE ATM
	SET DescAjusteCompra:= 'AJUSTE DE COMPRA';			-- Descripcion AJUSTE DE COMPRA
	SET DescDevolucion	:= 'DEVOLUCION';				-- Descripcion DEVOLUCIÖN

	SET Tipo_SAFI		:= 'WORKBENCH';					--  Programa
	SET Abono_EnLinea	:= '50';						-- Transaccion en Linea OXXO
	SET Abono_Archivo	:= '51';						-- Archivo Batch 510 (WALMART y SORIANA)
	SET Desc_Corresp	:= 'PAGO CORRESPONSALES';		-- Descripcion corresponsales

	SET Con_Principal	:= 1;							-- Numero de consulta

	-- Eliminamos registros
	TRUNCATE TABLE TARDEBTMPMOVS;
	TRUNCATE TABLE TARDEBCONCILIAMOVS;

	# CONSULTA PRINCIPAL
	IF (Par_NumCon = Con_Principal) THEN
		-- se insertan los movimientos externos
		INSERT INTO TARDEBTMPMOVS(
			ConciliaID,		DetalleID,			NumCuenta,		FechaConsumo,	FechaProceso,
			TipoTransaccion,ImporteOrigenTrans,	NumAutorizacion,EstatusConci)
		SELECT
			ConciliaID,		DetalleID,	NumCuenta,	FechaConsumo,	FechaProceso,
			TipoTransaccion,ImporteOrigenTrans,	NumAutorizacion,	EstatusConci
			FROM TARDEBCONCILIADETA
			WHERE EstatusConci != Est_Concilia
			AND TipoOperacion = Desc_Corresp; -- Validacion para excluir los corresponsales WALMART Y SORIANA

		-- se insertan todos los movimientos que no coincidan
		INSERT INTO TARDEBCONCILIAMOVS (
			ConciliaID,		DetalleID,			NumCuenta,		FechaConsumo,	FechaProceso,
			TipoTransaccion,ImporteOrigenTrans,	NumAutorizacion,TarDebMovID,	EstatusConci)
		SELECT
			ConciliaID,		DetalleID,			NumCuenta,		FechaConsumo,	FechaProceso,
			TipoTransaccion,ImporteOrigenTrans,	NumAutorizacion, Entero_Cero,	EstatusConci
			FROM TARDEBTMPMOVS
			WHERE EstatusConci != Est_Concilia;

		-- Se hace un SELECT con los datos insertados en la tabla
		SELECT
			IFNULL(NumAutorizacion, Entero_Cero) AS NumAutorizacion,
			IFNULL(FechaProceso, Fecha_Vacia) AS FechaProcesoExt,
			IFNULL(FechaConsumo, Fecha_Vacia) AS FechaConsumoExt,
			IFNULL(ConciliaID, Entero_Cero) AS ConciliaID,
			IFNULL(DetalleID, Entero_Cero) AS DetalleID,
			IFNULL(TipoTransaccion, Cadena_Vacia) AS TipoTransaccion,
			Desc_Corresp AS DescTransaccion,
			IFNULL(NumCuenta, Cadena_Vacia) AS NumCuenta,
			FORMAT(IFNULL(ImporteOrigenTrans, Entero_Cero), 2) AS MontoOpera
		FROM TARDEBCONCILIAMOVS;
	END IF;
END TerminaStore$$