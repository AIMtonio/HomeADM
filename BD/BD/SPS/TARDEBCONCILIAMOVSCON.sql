-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIAMOVSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCILIAMOVSCON`;
DELIMITER $$


CREATE PROCEDURE `TARDEBCONCILIAMOVSCON`(
	# =====================================================================================
	# ----- STORED QUE LISTA LOS MOVIMIENTOS DE CONCILIACION DE TARJETAS -------
	# =====================================================================================

    Par_NumCon 			TINYINT UNSIGNED,	-- Numero de consulta

    -- Parametros de Auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore:BEGIN

-- Declaracion de constantes
DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
DECLARE Entero_Cero				INT(11);		-- Entero vacio

DECLARE CompraNormal			CHAR(2);		-- Compra normal
DECLARE CompraRetiro			CHAR(2);		-- Compra retiro
DECLARE CompraTpoAire			CHAR(2);		-- Compra tiempo aire
DECLARE	AjusteCompra			CHAR(2);		-- Ajuste de compra
DECLARE Devolucion				CHAR(2);		-- Devolucion

DECLARE DescCompraNor			VARCHAR(30);		-- Descripcion de compra normal
DECLARE DescComRet				VARCHAR(30);		-- Descripcion de compra retiro
DECLARE DescComTpoAire			VARCHAR(30);		-- Descripcion de compra tiempo aire
DECLARE DescAjusteCompra		VARCHAR(30);		-- Descripcion de ajuste de cuenta
DECLARE DescDevolucion			VARCHAR(30);		-- Descripcion de devolucion

DECLARE Fecha_Vacia				DATE;			-- Facha vacia
DECLARE Est_NoConc				CHAR(1);		-- Estado No concilia
DECLARE Est_Concilia			CHAR(1);		-- Estado Concilia
DECLARE Var_ConciliaID			INT(11);		-- Variable de ID de concilia
DECLARE Var_DetalleID			INT(11);		-- Variavle de ID de detalle

DECLARE Var_NumCuenta			CHAR(16);		-- Variable numero de cuenta
DECLARE Var_FechaConsumo 		DATE;			-- Variable fecha de consumo
DECLARE Var_FechaProceso 		DATE;			-- Variable fecha de proceso
DECLARE Var_TipoTransaccion 	CHAR(2);		-- Variable tiempo de transaccion
DECLARE Var_ImporteOrigenTrans	DECIMAL(12,2);	-- Variable del importe origenes de transaccion

DECLARE Var_NumAutorizacion		CHAR(6);		-- Variable numeor de autorizacion
DECLARE Var_EstatusConci		CHAR(1);		-- Variable estado de la conciliacion
DECLARE Est_Procesado			CHAR(1);		-- Estado Procesaso
DECLARE Tipo_SAFI				VARCHAR(20);	--
DECLARE Abono_EnLinea			INT(11);		-- Transaccion el Linea OXXO

DECLARE Abono_Archivo			INT(11);		-- Archivo Batch 510 (WALMART y SORIANA)
DECLARE Desc_Corresp			VARCHAR(50);	-- Descripcion correspon

DECLARE DescAbono_EnLinea		VARCHAR(30);	-- Descripcion Abono en linea
DECLARE DescAbono_Archivo		VARCHAR(30);	-- Descripcion abono archivo
DECLARE	Con_Principal			INT(11);		-- Numero de consulta
DECLARE Llave_AutorizaTerceroTranTD		VARCHAR(50);	-- Llave AutorizaTerceroTranTD
DECLARE Var_AutorizaTerceroTranTD		VARCHAR(50);	-- Variable para almacenar el valor del campo AutorizaTerceroTranTD
DECLARE Con_SI							CHAR(1);		-- Constante SI
DECLARE Con_NO 							CHAR(1);		-- Constante NO


DECLARE  CursorMov  CURSOR FOR
	SELECT
		ConciliaID, 		DetalleID, 			NumCuenta, 			FechaConsumo,	FechaProceso,
		TipoTransaccion,	ImporteOrigenTrans, NumAutorizacion, 	EstatusConci
		FROM TARDEBTMPMOVS
		WHERE EstatusConci = Est_NoConc;

--  Asignacion de Constantes
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

SET DescCompraNor	:= 'COMPRA POS';				-- Descripcion COMPRAS POS
SET DescComRet		:= 'RETIRO EN COMPRA POS';		-- Descripcion RETIRO DE COMPRA POS
SET DescComTpoAire	:= 'COMPRA DE TIEMPO AIRE ATM';	-- Descripcion COMPRA DE TIEMPO AIRE ATM
SET DescAjusteCompra:= 'AJUSTE DE COMPRA';			-- Descripcion AJUSTE DE COMPRA
SET DescDevolucion	:= 'DEVOLUCION';				-- Descripcion devolucion
SET Tipo_SAFI		:= 'WORKBENCH';					--
SET Abono_EnLinea	:= '50';						-- Transaccion en Linea OXXO
SET Abono_Archivo	:= '51';						-- Archivo Batch 510 (WALMART y SORIANA)
SET Desc_Corresp	:= 'PAGO CORRESPONSALES'; 		-- Descripcion corresponsales

SET DescAbono_EnLinea := 'ABONO EN LINEA';			-- Descripcion ABONO EN LINEA
SET DescAbono_Archivo := 'ABONO ARCHIVO';			-- Descripcion ABONO ARCHIVO

SET Con_Principal	:=	1;							-- Numero de consulta
SET Con_NO						:= 'N';             -- Constante NO
SET Con_SI						:= 'S';             -- Constante SI
SET Llave_AutorizaTerceroTranTD	:= 'AutorizaTerceroTranTD';
-- Se obtiene la bandera de autorizacion de terceros
SET Var_AutorizaTerceroTranTD	:= IFNULL( FNPARAMTARJETAS(Llave_AutorizaTerceroTranTD), Con_NO);

-- Eliminamos registros
TRUNCATE TABLE TARDEBTMPMOVS;
TRUNCATE TABLE TARDEBCONCILIAMOVS;

	IF(Par_NumCon = Con_Principal) THEN

		-- CUANDO LA BANDERA ESTA APAGADA, NO SUFRE CAMBIOS LA LSITA ACTUAL
		IF(Var_AutorizaTerceroTranTD = Con_NO)THEN

			-- se insertan los movimientos internos
			INSERT INTO TARDEBCONCILIAMOVS(
				TarDebMovID, 	TipoOperacionID, 	TarjetaDebID, 	MontoOperacion, 	FechaOperacion,
				NumReferencia, 	EstatusConci,		ConciliaID,		DetalleID)
			SELECT
				TarDebMovID,	TipoOperacionID,	TarjetaDebID,	MontoOpe,	FechaHrOpe,
				NumTransaccion, EstatusConcilia, 	Entero_Cero,	Entero_Cero
				FROM TARDEBBITACORAMOVS
				WHERE (TipoOperacionID = CompraNormal OR TipoOperacionID = CompraRetiro
							OR TipoOperacionID = CompraTpoAire OR TipoOperacionID = AjusteCompra OR TipoOperacionID = Devolucion
							OR TipoOperacionID = Abono_EnLinea OR TipoOperacionID = Abono_Archivo)
					AND  EstatusConcilia = Est_NoConc AND Estatus = Est_Procesado
					AND TerminalID <> Tipo_SAFI;



			-- se insertan los movimientos externos
			INSERT INTO TARDEBTMPMOVS(
				ConciliaID,			DetalleID,			NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,	NumAutorizacion,	EstatusConci)
			SELECT
				ConciliaID,			DetalleID,			NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,	NumAutorizacion,	EstatusConci
				FROM TARDEBCONCILIADETA
				WHERE EstatusConci != Est_Concilia
				AND TipoOperacion != Desc_Corresp; -- Validacion para excluir los corresponsales WALMART Y SORIANA

			-- Se actualizan los valores de la tabla con los que coincidan en
			-- numero de transaccion, numero de tarjeta, monto
			UPDATE TARDEBCONCILIAMOVS movs,	TARDEBTMPMOVS con
			SET
				movs.ConciliaID			=	con.ConciliaID,
				movs.DetalleID			=	con.DetalleID,
				movs.NumCuenta			=	con.NumCuenta,
				movs.FechaConsumo		=	con.FechaConsumo,
				movs.FechaProceso		=	con.FechaProceso,
				movs.TipoTransaccion	=	con.TipoTransaccion,
				movs.ImporteOrigenTrans	=	con.ImporteOrigenTrans,
				movs.NumAutorizacion	=	con.NumAutorizacion,
				movs.EstatusConci		=	Est_Concilia,
				con.EstatusConci		= 	Est_Concilia
			WHERE CAST(con.NumAutorizacion AS UNSIGNED) 	=	CAST(movs.NumReferencia AS UNSIGNED)
				AND con.NumCuenta		=	movs.TarjetaDebID
				AND con.ImporteOrigenTrans = movs.MontoOperacion
				AND con.EstatusConci	= 	Est_NoConc;


			-- se insertan todos los movimientos que no coincidan
			INSERT INTO TARDEBCONCILIAMOVS (
				ConciliaID,			DetalleID,			NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,	NumAutorizacion,	TarDebMovID)
			SELECT
				ConciliaID,			DetalleID,			NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,	NumAutorizacion, 	Entero_Cero
				FROM TARDEBTMPMOVS
				WHERE EstatusConci != Est_Concilia;

			-- Se hace un SELECT con los datos insertados en la tabla
			SELECT
				IFNULL(TarDebMovID, Entero_Cero) AS TarDebMovID,
				IFNULL(TipoOperacionID, Cadena_Vacia) AS TipoOperacion,
				CASE TipoOperacionID
						WHEN CompraNormal	THEN DescCompraNor
						WHEN CompraRetiro 	THEN DescComRet
						WHEN CompraTpoAire	THEN DescComTpoAire
						WHEN AjusteCompra 	THEN DescAjusteCompra
						WHEN Devolucion 	THEN DescDevolucion
						WHEN Abono_EnLinea 	THEN DescAbono_EnLinea
						WHEN Abono_Archivo	THEN DescAbono_Archivo

					END AS DescOperacion,
				IFNULL(TarjetaDebID, Cadena_Vacia) AS TarjetaDebID,
				FORMAT(IFNULL(MontoOperacion, Entero_Cero), 2) AS MontoOperacion,
				IFNULL(FechaOperacion, Fecha_Vacia) AS FechaOperacion,
				IFNULL(LPAD(NumReferencia, 6, '0'), Cadena_Vacia) AS NumReferencia,

				IFNULL(ConciliaID, Entero_Cero)	AS ConciliaID,
				IFNULL(DetalleID, Entero_Cero) 	AS DetalleID,
				IFNULL(NumCuenta, Cadena_Vacia) AS TarjetaDebIDExt,
				IFNULL(FechaConsumo, Fecha_Vacia) AS FechaConsumoExt,
				IFNULL(FechaProceso, Fecha_Vacia) AS FechaProcesoExt,
				IFNULL(TipoTransaccion, Cadena_Vacia) AS TipoTransaccionExt,
				CASE TipoTransaccion
					WHEN '01' THEN DescCompraNor
					WHEN '18' THEN DescComRet
					WHEN '21' THEN DescDevolucion
					END AS DescOperacionExt,
				FORMAT(IFNULL(ImporteOrigenTrans, Entero_Cero), 2) AS MontoOperacionExt,
				IFNULL(NumAutorizacion, Cadena_Vacia) AS NumAutorizacionExt,
				IFNULL(EstatusConci, Cadena_Vacia) AS EstatusConci
			FROM TARDEBCONCILIAMOVS;
		END IF;

		-- SI LA BANDERA SE ENCUENTRA PRENDIDA, SE CONSULTA OTRAS CONDICIONES DE ISOTRX
		IF(Var_AutorizaTerceroTranTD = Con_SI)THEN

			-- se insertan los movimientos internos
			INSERT INTO TARDEBCONCILIAMOVS(
				TarDebMovID,		TipoOperacionID,	TarjetaDebID, 	MontoOperacion,		FechaOperacion,
				NumReferencia,		EstatusConci,		ConciliaID,		DetalleID
				)
			SELECT
				TarDebMovID,		TipoOperacionID,	TarjetaDebID,	MontoOpe,			FechaHrOpe,
				CodigoAprobacion,	EstatusConcilia,	Entero_Cero,	Entero_Cero
				FROM TARDEBBITACORAMOVS TD
				INNER JOIN CATTIPOPERACIONISOTRX Cat ON TD.TipoOperacionID = Cat.CodigoOperacion
					AND EstatusConcilia = Est_NoConc
					AND Estatus = Est_Procesado
					AND TerminalID <> Tipo_SAFI;

			-- se insertan los movimientos externos
			INSERT INTO TARDEBTMPMOVS(
				ConciliaID,			DetalleID,				NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,		NumAutorizacion,	EstatusConci
				)
			SELECT
				ConciliaID,			DetalleID,				NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,		NumAutorizacion,	EstatusConci
				FROM TARDEBCONCILIADETA
				WHERE EstatusConci != Est_Concilia
				AND TipoOperacion != Desc_Corresp; -- Validacion para excluir los corresponsales WALMART Y SORIANA

			-- Se actualizan los valores de la tabla con los que coincidan en
			-- numero de transaccion, numero de tarjeta, monto
			UPDATE TARDEBCONCILIAMOVS movs,	TARDEBTMPMOVS con
			SET
				movs.ConciliaID			=	con.ConciliaID,
				movs.DetalleID			=	con.DetalleID,
				movs.NumCuenta			=	con.NumCuenta,
				movs.FechaConsumo		=	con.FechaConsumo,
				movs.FechaProceso		=	con.FechaProceso,
				movs.TipoTransaccion	=	con.TipoTransaccion,
				movs.ImporteOrigenTrans	=	con.ImporteOrigenTrans,
				movs.NumAutorizacion	=	con.NumAutorizacion,
				movs.EstatusConci		=	Est_Concilia,
				con.EstatusConci		= 	Est_Concilia
			WHERE CAST(con.NumAutorizacion AS UNSIGNED) 	=	CAST(movs.NumReferencia AS UNSIGNED)
				AND con.NumCuenta		=	movs.TarjetaDebID
				AND con.ImporteOrigenTrans = movs.MontoOperacion
				AND con.EstatusConci	= 	Est_NoConc;

			-- se insertan todos los movimientos que no coincidan
			INSERT INTO TARDEBCONCILIAMOVS (
				ConciliaID,			DetalleID,			NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,	NumAutorizacion,	TarDebMovID
				)
			SELECT
				ConciliaID,			DetalleID,			NumCuenta,			FechaConsumo,	FechaProceso,
				TipoTransaccion,	ImporteOrigenTrans,	NumAutorizacion, 	Entero_Cero
				FROM TARDEBTMPMOVS
				WHERE EstatusConci != Est_Concilia;

			-- Se hace un SELECT con los datos insertados en la tabla
			SELECT
				IFNULL(TarDebMovID, Entero_Cero) AS TarDebMovID,
				IFNULL(TipoOperacionID, Cadena_Vacia) AS TipoOperacion,
				Cat.Descripcion AS DescOperacion,
				IFNULL(TarjetaDebID, Cadena_Vacia) AS TarjetaDebID,
				FORMAT(IFNULL(MontoOperacion, Entero_Cero), 2) AS MontoOperacion,
				IFNULL(FechaOperacion, Fecha_Vacia) AS FechaOperacion,
				IFNULL(LPAD(NumReferencia, 6, '0'), Cadena_Vacia) AS NumReferencia,
				IFNULL(ConciliaID, Entero_Cero)	AS ConciliaID,
				IFNULL(DetalleID, Entero_Cero) 	AS DetalleID,
				IFNULL(NumCuenta, Cadena_Vacia) AS TarjetaDebIDExt,
				IFNULL(FechaConsumo, Fecha_Vacia) AS FechaConsumoExt,
				IFNULL(FechaProceso, Fecha_Vacia) AS FechaProcesoExt,
				IFNULL(TipoTransaccion, Cadena_Vacia) AS TipoTransaccionExt,
				CASE TipoTransaccion
					WHEN '01' THEN DescCompraNor
					WHEN '18' THEN DescComRet
					WHEN '21' THEN DescDevolucion
					END AS DescOperacionExt,
				FORMAT(IFNULL(ImporteOrigenTrans, Entero_Cero), 2) AS MontoOperacionExt,
				IFNULL(NumAutorizacion, Cadena_Vacia) AS NumAutorizacionExt,
				IFNULL(EstatusConci, Cadena_Vacia) AS EstatusConci
			FROM TARDEBCONCILIAMOVS TD
			INNER JOIN CATTIPOPERACIONISOTRX Cat ON TD.TipoOperacionID = Cat.CodigoOperacion;
		END IF;
	END IF;
END TerminaStore$$