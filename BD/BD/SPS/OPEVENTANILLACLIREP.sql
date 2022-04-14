-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPEVENTANILLACLIREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPEVENTANILLACLIREP`;DELIMITER $$

CREATE PROCEDURE `OPEVENTANILLACLIREP`(
	Par_Fechainicio 	DATE,
	Par_FechaFin		DATE,

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES --
DECLARE Var_Sentencia 	TEXT(80000);

-- DECLARACION DE CONSTANTES --
DECLARE ConsecutivoUno	INT(11);
DECLARE CADENA_SI		VARCHAR(1);
DECLARE Entero_Cero 	INT(11);
DECLARE Pago_Oportu		VARCHAR(100);
DECLARE PagoCanSocio	INT(11);
DECLARE PagoServifun	INT(11);
DECLARE Servifun		INT(11);
DECLARE PagoCobro		INT(11);
DECLARE CobSegAyu		INT(11);
DECLARE ApliSeguAyu		INT(11);
DECLARE PagoSeg			INT(11);
DECLARE RecCarteraCas	INT(11);
DECLARE PagCobRiesgo	INT(11);
DECLARE TransferCtasE	INT(11);
DECLARE TransferCtasS	INT(11);

-- tipos de instrumnetos --
DECLARE CuentaAhorro	INT(11);
DECLARE Cliente			INT(11);
DECLARE Credito			INT(11);
DECLARE InvPlazo		INT(11);
DECLARE Servicio		INT(11);
DECLARE Cajas			INT(11);
DECLARE Oportunidades	INT(11);
DECLARE Tarjeta			INT(11);

-- Asignacion de constantes --
SET ConsecutivoUno	:=1;
SET CADENA_SI		:='S';
SET Entero_Cero		:=0;
SET Pago_Oportu		:='PAGO DE PROGRAMA OPORTUNIDADES';
SET PagoCanSocio	:=116; -- PAGO CANCELACION SOCIO
SET PagoServifun	:=91;
SET Servifun		:=92;
SET PagoCobro		:=68;
SET CobSegAyu		:=69;
SET ApliSeguAyu		:=70;
SET PagoSeg			:=71;
SET RecCarteraCas	:=87; -- 'ENTRADA DE EFECTIVO POR RECUPERACION DE CARTERA CASTIGADA'
SET PagCobRiesgo	:=38; -- 'PAGO COBERTURA DE RIESGO'
SET TransferCtasE	:=62; -- ENTRADA TRANSFERENCIA ENTRE CUENTAS
SET TransferCtasS	:=63; -- SALIDA TRANSFERENCIA ENTRE CUENTAS

SET  CuentaAhorro	:=2;
SET  Cliente		:=4;
SET  Credito		:=11;
SET  InvPlazo		:=13;
SET	Servicio		:=8;
SET Cajas			:=15;
SET Oportunidades	:=23;
SET Tarjeta			:=14;

DROP TABLE IF EXISTS TMPOPERACIONESCLI;
CREATE TEMPORARY TABLE TMPOPERACIONESCLI ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESCLI (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
SELECT D.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= Cliente -- CLIENTES
			AND CL.ClienteID	= DE.Instrumento
			AND D.Consecutivo = ConsecutivoUno
			AND D.TipoOperacion != PagoServifun
			AND D.TipoOperacion != Servifun
			AND D.TipoOperacion != PagoCobro
			AND D.TipoOperacion != ApliSeguAyu
			AND D.TipoOperacion != PagoSeg
			AND D.TipoOperacion != CobSegAyu;

-- CUENTAS --
DROP TABLE IF EXISTS TMPOPERACIONESCTA;
CREATE TEMPORARY TABLE TMPOPERACIONESCTA ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESCTA (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
SELECT D.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL,
				CUENTASAHO		AS CA
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio and Par_FechaFin
			AND DE.TipoInstrumentoID	= CuentaAhorro -- CUENTAS
			AND CA.CuentaAhoID	= DE.Instrumento
			AND CL.ClienteID	= CA.ClienteID
			AND D.Consecutivo 	= ConsecutivoUno
			AND D.TipoOperacion !=TransferCtasE -- ENTRADA TRANSFERENCIA ENTRE CUENTAS
			AND D.TipoOperacion !=TransferCtasS -- SALIDA TRNAFERENCIA ENTRE CUENTAS
			GROUP BY DE.NumTransaccion, 	D.SucursalID, 	Abonos, 			Cargos,
					 DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen,	DE.Fecha;
-- INVERSIONES --
DROP TABLE IF EXISTS TMPOPERACIONESINV;

CREATE TEMPORARY TABLE TMPOPERACIONESINV ( SucursalID INT(11),
											Entradas	DECIMAL(16,2),
											Salidas		DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		bigint,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESINV (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT D.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL,
				INVERSIONES		AS IV
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= InvPlazo -- INVERSIONES A PLAZO
			AND IV.InversionID	= DE.Instrumento
			AND CL.ClienteID	= IV.ClienteID
			AND D.Consecutivo 	= ConsecutivoUno;

-- SERVICIOS --
DROP TABLE IF EXISTS TMPOPERACIONESSER;

CREATE TEMPORARY TABLE TMPOPERACIONESSER ( SucursalID 			INT(11),
                                            Entradas    		DECIMAL(16,2),
                                            Salidas       		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            SucursalOrigen      INT(11),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESSER (SucursalID,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT D.SucursalID,
            DE.Abonos AS Entradas,
            DE.Cargos AS Salidas,
            DE.TipoInstrumentoID,     DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
        FROM     CAJASMOVS          AS D,
                DETALLEPOLIZA    	AS DE,
                CLIENTES        	AS CL,
				PAGOSERVICIOS		AS PA,
                CATALOGOSERV    	AS CA
        WHERE    DE.NumTransaccion = D.NumTransaccion
			AND PA.NumTransaccion = D.NumTransaccion
            AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
            AND DE.TipoInstrumentoID    = Servicio -- pago servicio
		    AND CL.ClienteID = PA.ClienteID
			AND CA.CatalogoServID    = DE.Instrumento
			AND D.Instrumento    = DE.Instrumento
            AND CA.RequiereCliente= Cadena_SI
            AND D.Consecutivo     = ConsecutivoUno;

-- PAGO OPORTUNIDADES --
DROP TABLE IF EXISTS TMPOPERACIONESOPOO;
CREATE TEMPORARY TABLE TMPOPERACIONESOPOO ( CCostosOrigen 		INT(11),-- ORIGEN
                                            Entradas    		DECIMAL(16,2),
                                            Salidas      		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESOPOO (CCostosOrigen,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)

-- envia --
SELECT CentroCostoID, Cargos, Abonos, TipoInstrumentoID, Instrumento, NumTransaccion, Fecha
	FROM DETALLEPOLIZA
	WHERE Abonos > Entero_Cero
	AND Fecha BETWEEN Par_Fechainicio AND 	Par_FechaFin
	AND TipoInstrumentoID =  Cajas --  cajas
GROUP BY NumTransaccion,	CentroCostoID, 	Cargos, 	Abonos,
		 TipoInstrumentoID, Instrumento,	Fecha;

DROP TABLE IF EXISTS TMPOPERACIONESOPOD;
CREATE TEMPORARY TABLE TMPOPERACIONESOPOD ( CCostosDestino 		INT(11),-- ORIGEN
                                            Entradas    		DECIMAL(16,2),
                                            Salidas       		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESOPOD (CCostosDestino,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)


-- Recibe
SELECT CentroCostoID, Cargos, Abonos, TipoInstrumentoID, Instrumento, NumTransaccion, Fecha
	FROM DETALLEPOLIZA
	WHERE tipoInstrumentoID= Oportunidades
    AND Descripcion = Pago_Oportu
	AND Fecha BETWEEN Par_Fechainicio AND 	Par_FechaFin
	AND Cargos >Entero_Cero
GROUP BY NumTransaccion,	CentroCostoID, 	Cargos, Abonos,
		 TipoInstrumentoID, Instrumento,	Fecha;

DROP TABLE IF EXISTS TMPOPERACIONESOPO;
CREATE TEMPORARY TABLE TMPOPERACIONESOPO ( SucursalID 			INT(11),-- ORIGEN DE MOVIMIENTO
                                            Entradas    		DECIMAL(16,2),
                                            Salidas       		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            SucursalOrigen      INT(11),-- SUC ORIGEN DEL CLIENTE DESTINO
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESOPO (SucursalID,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT tmpo.CCostosOrigen, tmpo.Entradas, tmpd.Entradas, tmpd.TipoInstrumentoID, tmpd.Instrumento,
	tmpd.CCostosDestino,tmpd.NumTransaccion, tmpd.Fecha
	FROM TMPOPERACIONESOPOD tmpd,
		 TMPOPERACIONESOPOO tmpo
		WHERE tmpd.NumTransaccion = tmpo.NumTransaccion;

-- CANCELACION SOCIO --
DROP TABLE IF EXISTS TMPOPERACIONESCANO;
CREATE TEMPORARY TABLE TMPOPERACIONESCANO ( CCostosOrigen 		INT(11),-- ORIGEN
                                            Entradas    		DECIMAL(16,2),
                                            Salidas       		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESCANO (CCostosOrigen,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)

-- envia (Origen)--
SELECT de.CentroCostoID, de.Cargos,sum(de.Abonos) AS Abonos, de.TipoInstrumentoID, de.Instrumento, de.NumTransaccion, de.Fecha
	FROM DETALLEPOLIZA de,
		CAJASMOVS ca
	WHERE de.Fecha BETWEEN Par_Fechainicio AND 	Par_FechaFin
	AND de.Abonos > Entero_Cero
	AND ca.TipoOperacion = PagoCanSocio -- PAGO CANCELACION SOCIO
	AND de.TipoInstrumentoID =  Cajas -- CAJAS
	AND de.NumTransaccion = ca.NumTransaccion
	GROUP BY de.NumTransaccion, 	de.CentroCostoID, 	de.Cargos,
			 de.TipoInstrumentoID, 	de.Instrumento, 	de.Fecha;

-- pago de cancelaciÃ³n de socio --
DROP TABLE IF EXISTS TMPOPERACIONESCAND;
CREATE TEMPORARY TABLE TMPOPERACIONESCAND ( CCostosDestino 		INT(11),-- ORIGEN
                                            Entradas    		DECIMAL(16,2),
                                            Salidas       		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESCAND (CCostosDestino,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)


-- Recibe
SELECT de.CentroCostoID, de.Cargos, de.Cargos, de.TipoInstrumentoID, de.Instrumento, de.NumTransaccion, de.Fecha
	FROM DETALLEPOLIZA de,
		CAJASMOVS ca
	WHERE de.Fecha BETWEEN Par_Fechainicio AND 	Par_FechaFin
	AND de.Cargos >= Entero_Cero
	AND ca.TipoOperacion = PagoCanSocio -- PAGO CANCELACION SOCIO
	AND de.TipoInstrumentoID =  Cajas -- CAJAS
	AND de.NumTransaccion = ca.NumTransaccion
	GROUP BY de.NumTransaccion, 	de.CentroCostoID, 	de.Cargos, 	de.Cargos,
			 de.TipoInstrumentoID, 	de.Instrumento, 	de.Fecha;

-- CONSIDERANDO CANCELACIÃN DE SOCIO --
DROP TABLE IF EXISTS TMPOPERACIONESCAN;
CREATE TEMPORARY TABLE TMPOPERACIONESCAN ( SucursalID 			INT(11),-- ORIGEN DE MOVIMIENTO
                                            Salidas    			DECIMAL(16,2),
                                           Entradas     		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            SucursalOrigen      INT(11),-- SUC ORIGEN DEL CLIENTE DESTINO
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESCAN (SucursalID,    Salidas,    Entradas,TipoInstrumentoID,
                                Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT tmpco.CCostosOrigen, tmpco.Entradas, tmpco.Salidas, tmpco.TipoInstrumentoID, tmpco.Instrumento,
	tmpcd.CCostosDestino,tmpco.NumTransaccion, tmpco.Fecha
	FROM TMPOPERACIONESCAND tmpcd,
		 TMPOPERACIONESCANO tmpco
		WHERE tmpcd.NumTransaccion = tmpco.NumTransaccion;

-- SERVIFUN --
DROP TABLE IF EXISTS TMPSERVIFUN;
CREATE TEMPORARY TABLE TMPSERVIFUN (		SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPSERVIFUN (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
SELECT D.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha between Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= Cliente -- CLIENTES
			AND CL.ClienteID	= (SELECT ClienteID FROM SERVIFUNFOLIOS WHERE ServifunFolioID = DE.Instrumento)
			AND D.Consecutivo = ConsecutivoUno;

-- APLICA SEGURO DE VIDA --
DROP TABLE IF EXISTS TMPSEGUROVIDAAYUDA;
CREATE TEMPORARY TABLE TMPSEGUROVIDAAYUDA ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPSEGUROVIDAAYUDA (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT D.SucursalID,
			max(DE.Abonos) AS Entradas,
			D.MontoEnFirme AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= Cliente -- CLIENTES
			AND CL.ClienteID	= DE.Instrumento
			AND D.Consecutivo = ConsecutivoUno
			AND (D.TipoOperacion = ApliSeguAyu -- APLICA SEGURO DE VIDA
			OR D.TipoOperacion = PagoSeg -- PAGO APLICA SEGURO DE VIDA
			)
			GROUP BY D.SucursalID,			DE.NumTransaccion,	D.MontoEnFirme,
					 DE.TipoInstrumentoID, 	DE.Instrumento, 	CL.SucursalOrigen,	DE.Fecha;

-- RECUPERACION DE CARTERA CASTIGADA --
DROP TABLE IF EXISTS TMPOPERACIONESCRE;
CREATE TEMPORARY TABLE TMPOPERACIONESCRE ( 	SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESCRE (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT D.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL,
				CREDITOS		AS CR
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= Credito -- CREDITOS
			AND CR.CreditoID	= DE.Instrumento
			AND CL.ClienteID	= CR.ClienteID
			AND D.Consecutivo 	= ConsecutivoUno
			AND (D.TipoOperacion = RecCarteraCas -- 'ENTRADA DE EFECTIVO POR RECUPERACION DE CARTERA CASTIGADA'
			OR 	D.TipoOperacion = PagCobRiesgo); -- COBERTURA DE RIESGO

-- COBRO ANUALIDAD DE TARJETAS --
DROP TABLE IF EXISTS TMPOPERACIONESTAR;
CREATE TEMPORARY TABLE TMPOPERACIONESTAR ( 	SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESTAR (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
SELECT D.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL,
				TARJETADEBITO		AS TR
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= Tarjeta -- TARJETAS
			AND TR.TarjetaDebID	= DE.Instrumento
			AND CL.ClienteID	= (SELECT ClienteID FROM TARJETADEBITO WHERE TarjetaDebID =  TR.TarjetaDebID)
			AND D.Consecutivo 	= ConsecutivoUno;

-- TRANSFERENCIA ENTRE CUENTAS --
DROP TABLE IF EXISTS TMPOPETRANCTA;
CREATE TEMPORARY TABLE TMPOPETRANCTA ( 		SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPETRANCTA (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
SELECT D.SucursalID,
			max(Abonos)AS Entradas,
			Cargos ASSalidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM	CAJASMOVS  		AS D,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL,
				CUENTASAHO		AS CA
		WHERE	DE.NumTransaccion = D.NumTransaccion
			AND DE.Fecha between Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= CuentaAhorro -- CUENTAS
			AND CA.CuentaAhoID	= DE.Instrumento
			AND CL.ClienteID	= CA.ClienteID
			AND D.Consecutivo 	= ConsecutivoUno
			AND D.TipoOperacion =TransferCtasE
			GROUP BY DE.NumTransaccion, D.SucursalID, Cargos, DE.TipoInstrumentoID, DE.Instrumento,
			CL.SucursalOrigen, DE.Fecha; -- ENTRADA TRANSFERENCIA ENTRE CUENTAS


-- ****************** HISTORICO ******************** --
-- CLIENTES  --
DROP TABLE IF EXISTS TMPOPERACIONESCLI2;

CREATE TEMPORARY TABLE TMPOPERACIONESCLI2 ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESCLI2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
	SELECT Dt.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DEt.TipoInstrumentoID, 	DEt.Instrumento, CL.SucursalOrigen, DEt.NumTransaccion, DEt.Fecha
		FROM 	`HIS-CAJASMOVS` AS Dt,
				DETALLEPOLIZA	AS DEt,
				CLIENTES		AS CL
		WHERE	DEt.NumTransaccion = Dt.NumTransaccion
			AND DEt.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DEt.TipoInstrumentoID	= Cliente
			AND CL.ClienteID			= DEt.Instrumento
			AND Dt.Consecutivo 			= ConsecutivoUno
			AND Dt.TipoOperacion		!=PagoServifun
			AND Dt.TipoOperacion		!=Servifun;
-- CUENTAS --
DROP TABLE IF EXISTS TMPOPERACIONESCTA2;

CREATE TEMPORARY TABLE TMPOPERACIONESCTA2 ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESCTA2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
	SELECT Dt.SucursalID,
			DEt.Abonos AS Entradas,
			DEt.Cargos AS Salidas,
			DEt.TipoInstrumentoID, 	DEt.Instrumento, CL.SucursalOrigen, DEt.NumTransaccion, DEt.Fecha
		FROM 	`HIS-CAJASMOVS` AS Dt,
				DETALLEPOLIZA	AS DEt,
				CLIENTES		AS CL,
				CUENTASAHO		AS CA
		WHERE	DEt.NumTransaccion = Dt.NumTransaccion
			AND DEt.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DEt.TipoInstrumentoID	= CuentaAhorro
			AND CA.CuentaAhoID	= DEt.Instrumento
			AND CL.ClienteID	= CA.ClienteID
			AND Dt.TipoOperacion !=TransferCtasE -- ENTRADA TRANSFERENCIA ENTRE CUENTAS
			AND Dt.TipoOperacion !=TransferCtasS -- SALIDA TRNAFERENCIA ENTRE CUENTAS
			AND Dt.Consecutivo 	= ConsecutivoUno
			GROUP BY DEt.NumTransaccion,	Dt.SucursalID,		DEt.Abonos,			DEt.Cargos,
					 DEt.TipoInstrumentoID,	DEt.Instrumento,	CL.SucursalOrigen,	DEt.Fecha;

	-- INVERSIONES --
DROP TABLE IF EXISTS TMPOPERACIONESINV2;

CREATE TEMPORARY TABLE TMPOPERACIONESINV2 ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESINV2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
	SELECT Dt.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DEt.TipoInstrumentoID, 	DEt.Instrumento, CL.SucursalOrigen, DEt.NumTransaccion, DEt.Fecha
		FROM 	`HIS-CAJASMOVS` AS Dt,
				DETALLEPOLIZA	AS DEt,
				CLIENTES		AS CL,
				INVERSIONES		AS IV
		WHERE	DEt.NumTransaccion = Dt.NumTransaccion
			AND DEt.Fecha between Par_Fechainicio and Par_FechaFin
			AND DEt.TipoInstrumentoID	= InvPlazo
			AND IV.InversionID	= DEt.Instrumento
			AND CL.ClienteID	= IV.ClienteID
			AND Dt.Consecutivo 	= ConsecutivoUno;

DROP TABLE IF EXISTS TMPOPERACIONESSER2;

CREATE TEMPORARY TABLE TMPOPERACIONESSER2 ( SucursalID 			INT(11),
                                            Entradas   			DECIMAL(16,2),
                                            Salidas       		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            SucursalOrigen      INT(11),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESSER2 (SucursalID,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT Dt.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DEt.TipoInstrumentoID, 	DEt.Instrumento, CL.SucursalOrigen, DEt.NumTransaccion, DEt.Fecha
		FROM 	`HIS-CAJASMOVS` AS Dt,
				DETALLEPOLIZA	AS DEt,
                CLIENTES        AS CL,
				PAGOSERVICIOS	AS PA,
                CATALOGOSERV    AS CA
        WHERE    DEt.NumTransaccion = Dt.NumTransaccion
			AND PA.NumTransaccion = Dt.NumTransaccion
            AND DEt.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
            AND DEt.TipoInstrumentoID	= Servicio -- pago servicio
		    AND CL.ClienteID 			= PA.ClienteID
			AND CA.CatalogoServID		= DEt.Instrumento
			AND Dt.Instrumento			= DEt.Instrumento
            AND CA.RequiereCliente		= Cadena_Si
            AND Dt.Consecutivo			= ConsecutivoUno;

-- PAGO OPORTUNIDADES --
DROP TABLE IF EXISTS TMPOPERACIONESOPOO2;
CREATE TEMPORARY TABLE TMPOPERACIONESOPOO2 (CCostosOrigen 		INT(11),-- ORIGEN
											Entradas    		DECIMAL(16,2),
                                            Salidas        		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESOPOO2 (CCostosOrigen,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)

-- envia --
SELECT CentroCostoID, Cargos, Abonos, TipoInstrumentoID, Instrumento, NumTransaccion, Fecha
	FROM `HIS-DETALLEPOL`
	WHERE Abonos > Entero_Cero
	AND Fecha BETWEEN Par_Fechainicio AND 	Par_FechaFin
	AND TipoInstrumentoID =  Cajas --  cajas
GROUP BY NumTransaccion, 	CentroCostoID, 	Cargos, Abonos,
		 TipoInstrumentoID, Instrumento, 	Fecha;

DROP TABLE IF EXISTS TMPOPERACIONESOPOD;
CREATE TEMPORARY TABLE TMPOPERACIONESOPOD ( CCostosDestino 		INT(11),-- ORIGEN
                                            Entradas    		DECIMAL(16,2),
                                            Salidas        		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESOPOD (CCostosDestino,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)


-- Recibe
SELECT CentroCostoID, Cargos, Abonos, TipoInstrumentoID, Instrumento, NumTransaccion, Fecha
	FROM `HIS-DETALLEPOL`
	WHERE tipoInstrumentoID= Oportunidades
    AND Descripcion = Pago_Oportu
	AND Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
	AND Cargos >Entero_Cero
GROUP BY NumTransaccion,	CentroCostoID, 	Cargos, Abonos,
		 TipoInstrumentoID, Instrumento, 	Fecha;

DROP TABLE IF EXISTS TMPOPERACIONESOPO2;
CREATE TEMPORARY TABLE TMPOPERACIONESOPO2 ( SucursalID 			INT(11),-- ORIGEN DE MOVIMIENTO
                                            Entradas    		DECIMAL(16,2),
                                            Salidas       		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            SucursalOrigen      INT(11),-- SUC ORIGEN DEL CLIENTE DESTINO
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESOPO2 (SucursalID,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT tmpo.CCostosOrigen, tmpo.Entradas, tmpd.Entradas, tmpd.TipoInstrumentoID, tmpd.Instrumento,
	tmpd.CCostosDestino,tmpd.NumTransaccion, tmpd.Fecha
	FROM TMPOPERACIONESOPOD tmpd,
		 TMPOPERACIONESOPOO tmpo
		where tmpd.NumTransaccion = tmpo.NumTransaccion;

-- HISTORICO CANCELACION SOCIO --
DROP TABLE IF EXISTS TMPOPERACIONESCANOH;
CREATE TEMPORARY TABLE TMPOPERACIONESCANOH (CCostosOrigen 		INT(11),-- ORIGEN
											Entradas    		DECIMAL(16,2),
                                            Salidas        		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESCANOH (CCostosOrigen,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)

-- envia (Origen)--
SELECT de.CentroCostoID, de.Cargos,sum(de.Abonos) AS Abonos, de.TipoInstrumentoID, de.Instrumento, de.NumTransaccion, de.Fecha
	FROM DETALLEPOLIZA de,
		`HIS-CAJASMOVS` cah
	WHERE de.Fecha BETWEEN Par_Fechainicio AND 	Par_FechaFin
	AND de.Abonos > Entero_Cero
	AND cah.TipoOperacion = PagoCanSocio -- PAGO CANCELACION SOCIO
	AND de.TipoInstrumentoID =  Cajas -- CAJAS
	AND de.NumTransaccion = cah.NumTransaccion
	GROUP BY de.NumTransaccion,	 	de.CentroCostoID,	de.Cargos,
			 de.TipoInstrumentoID,	de.Instrumento,		de.Fecha;

-- pago de cancelaciÃ³n de socio --
DROP TABLE IF EXISTS TMPOPERACIONESCANDH;
CREATE TEMPORARY TABLE TMPOPERACIONESCANDH (CCostosDestino 		INT(11),-- ORIGEN
                                            Entradas    		DECIMAL(16,2),
                                            Salidas        		DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESCANDH (CCostosDestino,    Entradas,    Salidas,TipoInstrumentoID,
                                Instrumento, NumTransaccion, Fecha)


-- Recibe
SELECT de.CentroCostoID, de.Cargos, de.Cargos, de.TipoInstrumentoID, de.Instrumento, de.NumTransaccion, de.Fecha
	FROM DETALLEPOLIZA de,
		`HIS-CAJASMOVS` cah
	WHERE de.Fecha BETWEEN Par_Fechainicio AND 	Par_FechaFin
	AND de.Cargos >= Entero_Cero
	AND cah.TipoOperacion = PagoCanSocio -- PAGO CANCELACION SOCIO
	AND de.TipoInstrumentoID =  Cajas -- CAJAS
	AND de.NumTransaccion = cah.NumTransaccion
	GROUP BY de.NumTransaccion,		de.CentroCostoID, 	de.Cargos, de.Cargos,
			 de.TipoInstrumentoID,	de.Instrumento,		de.Fecha;

-- CONSIDERANDO CANCELACIÃN DE SOCIO --
DROP TABLE IF EXISTS TMPOPERACIONESCANH;
CREATE TEMPORARY TABLE TMPOPERACIONESCANH ( SucursalID 			INT(11),-- ORIGEN DE MOVIMIENTO
                                            Salidas    			DECIMAL(16,2),
                                            Entradas        	DECIMAL(16,2),
                                            TipoInstrumentoID   INT(11),
                                            Instrumento         VARCHAR(80),
                                            SucursalOrigen      INT(11),-- SUC ORIGEN DEL CLIENTE DESTINO
                                            NumTransaccion      BIGINT,
                                            Fecha               DATE
                                                        );

INSERT INTO TMPOPERACIONESCANH (SucursalID,    Salidas,    Entradas,TipoInstrumentoID,
                                Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT tmcoh.CCostosOrigen, tmcoh.Entradas, tmcoh.Salidas, tmcoh.TipoInstrumentoID, tmcoh.Instrumento,
	tmcdh.CCostosDestino,tmcoh.NumTransaccion, tmcoh.Fecha
	FROM TMPOPERACIONESCANDH tmcdh,
		 TMPOPERACIONESCANOH tmcoh
		WHERE tmcdh.NumTransaccion = tmcoh.NumTransaccion;

-- SERVIFUN  --
DROP TABLE IF EXISTS TMPSERVIFUN2;

CREATE TEMPORARY TABLE TMPSERVIFUN2 ( 		SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPSERVIFUN2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
	SELECT Dt.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DEt.TipoInstrumentoID, 	DEt.Instrumento, CL.SucursalOrigen, DEt.NumTransaccion, DEt.Fecha
		FROM 	`HIS-CAJASMOVS` AS Dt,
				DETALLEPOLIZA	AS DEt,
				CLIENTES		AS CL
		WHERE	DEt.NumTransaccion = Dt.NumTransaccion
			AND DEt.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DEt.TipoInstrumentoID	= Cliente
			AND CL.ClienteID			= (SELECT ClienteID FROM SERVIFUNFOLIOS WHERE ServifunFolioID = DEt.Instrumento)
			AND Dt.Consecutivo 			= ConsecutivoUno;

-- APLICA SEGURO DE VIDA --
DROP TABLE IF EXISTS TMPSEGUROVIDAAYUDA2;
CREATE TEMPORARY TABLE TMPSEGUROVIDAAYUDA2 (SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPSEGUROVIDAAYUDA2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)

SELECT Dt.SucursalID,
			max(DE.Abonos) AS Entradas,
			Dt.MontoEnFirme AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	`HIS-CAJASMOVS` AS Dt,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL
		WHERE	DE.NumTransaccion = Dt.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= Cliente -- CLIENTES
			AND CL.ClienteID	= DE.Instrumento
			AND Dt.Consecutivo = ConsecutivoUno
			AND (Dt.TipoOperacion = ApliSeguAyu -- APLICA SEGURO DE VIDA
			OR Dt.TipoOperacion = PagoSeg -- PAGO APLICA SEGURO DE VIDA
			)
			GROUP BY NumTransaccion,		Dt.SucursalID,  Dt.MontoEnFirme,
					 DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen,	DE.Fecha;

-- RECUPERACION CARTERA CASTIGADA --
DROP TABLE IF EXISTS TMPOPERACIONESCRE2;

CREATE TEMPORARY TABLE TMPOPERACIONESCRE2 ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESCRE2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)

	SELECT Dt.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DEt.TipoInstrumentoID, 	DEt.Instrumento, CL.SucursalOrigen, DEt.NumTransaccion, DEt.Fecha
		FROM 	`HIS-CAJASMOVS` AS Dt,
				DETALLEPOLIZA	AS DEt,
				CLIENTES		AS CL,
				CREDITOS		AS CR
		WHERE	DEt.NumTransaccion = Dt.NumTransaccion
			AND DEt.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DEt.TipoInstrumentoID	= Credito -- CREDITOS
			AND CR.CreditoID	= DEt.Instrumento
			AND CL.ClienteID	= CR.ClienteID
			AND Dt.Consecutivo 	= ConsecutivoUno
			AND (Dt.TipoOperacion = RecCarteraCas -- 'RECUPERACION CARTERA CASTIGA'
			OR Dt.TipoOperacion = PagCobRiesgo); -- COBERTURA DE RIESGO

-- COBRO ANUALIDAD DE TARJETAS --
DROP TABLE IF EXISTS TMPOPERACIONESTAR2;
CREATE TEMPORARY TABLE TMPOPERACIONESTAR2 ( SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERACIONESTAR2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
SELECT Dt.SucursalID,
			Abonos AS Entradas,
			Cargos AS Salidas,
			DE.TipoInstrumentoID, 	DE.Instrumento, CL.SucursalOrigen, DE.NumTransaccion, DE.Fecha
		FROM 	`HIS-CAJASMOVS`	AS Dt,
				DETALLEPOLIZA	AS DE,
				CLIENTES		AS CL,
				TARJETADEBITO		AS TR
		WHERE	DE.NumTransaccion = Dt.NumTransaccion
			AND DE.Fecha BETWEEN Par_Fechainicio AND Par_FechaFin
			AND DE.TipoInstrumentoID	= Tarjeta -- TARJETAS
			AND TR.TarjetaDebID	= DE.Instrumento
			AND CL.ClienteID	= (SELECT ClienteID FROM TARJETADEBITO WHERE TarjetaDebID =  TR.TarjetaDebID)
			AND Dt.Consecutivo 	= ConsecutivoUno;

-- TRANSFERENCIA ENTRE CUENTAS --
DROP TABLE IF EXISTS TMPOPERATRANCTA2;

CREATE TEMPORARY TABLE TMPOPERATRANCTA2 ( 	SucursalID 			INT(11),
											Entradas			DECIMAL(16,2),
											Salidas				DECIMAL(16,2),
											TipoInstrumentoID	INT(11),
											Instrumento			VARCHAR(80),
											SucursalOrigen		INT(11),
											NumTransaccion		BIGINT,
											Fecha				DATE
														);

INSERT INTO TMPOPERATRANCTA2 (SucursalID,	Entradas,	Salidas,TipoInstrumentoID,
								Instrumento,SucursalOrigen, NumTransaccion, Fecha)
	SELECT Dt.SucursalID,
			max(Abonos) as Entradas,
			Cargos as Salidas,
			DEt.TipoInstrumentoID, 	DEt.Instrumento, CL.SucursalOrigen, DEt.NumTransaccion, DEt.Fecha
		FROM 	`HIS-CAJASMOVS`  		AS Dt,
				DETALLEPOLIZA	AS DEt,
				CLIENTES		AS CL,
				CUENTASAHO		AS CA
		WHERE	DEt.NumTransaccion = Dt.NumTransaccion
			AND DEt.Fecha between Par_Fechainicio AND Par_FechaFin
			AND DEt.TipoInstrumentoID	= CuentaAhorro
			AND CA.CuentaAhoID	= DEt.Instrumento
			AND CL.ClienteID	= CA.ClienteID
			AND Dt.TipoOperacion =TransferCtasE -- ENTRADA TRANSFERENCIA ENTRE CUENTAS
			AND Dt.Consecutivo 	= ConsecutivoUno
		GROUP BY DEt.NumTransaccion, Dt.SucursalID, Cargos, DEt.TipoInstrumentoID, DEt.Instrumento,
			CL.SucursalOrigen, DEt.Fecha;

SET Var_Sentencia :=' SELECT SucursalID as CentroOperacion,ce.Descripcion as SucOperacion, sum(Entradas) as Entradas,sum(Salidas) as Salidas, ';
SET Var_Sentencia :=CONCAT(Var_Sentencia,' TipoInstrumentoID,Instrumento,SucursalOrigen as CentroCostoSocio,cen.Descripcion as MovSociosSuc,Fecha, "Socio" as TipoRegistro ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' from( ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESINV) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCLI) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCTA) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESSER) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESOPO) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCAN) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPSEGUROVIDAAYUDA) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPSERVIFUN) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCRE) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESTAR) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPETRANCTA) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESINV2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCLI2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCTA2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESOPO2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCANH) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPSERVIFUN2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESCRE2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESTAR2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPSEGUROVIDAAYUDA2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERATRANCTA2) ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' UNION ALL ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' (SELECT * FROM TMPOPERACIONESSER2)) as tmp ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CENTROCOSTOS ce ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON tmp.SucursalID = ce.CentroCostoID ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' INNER JOIN CENTROCOSTOS cen ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' ON cen.CentroCostoID = tmp.SucursalOrigen ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' where SucursalID != SucursalOrigen ');
SET Var_Sentencia :=CONCAT(Var_Sentencia,' GROUP BY Fecha, SucursalID, SucursalOrigen, ce.Descripcion, TipoInstrumentoID, Instrumento, cen.Descripcion; ');

SET @Sentencia		= (Var_Sentencia);

PREPARE STOPEVENTANILLACLIREP FROM @Sentencia;
EXECUTE STOPEVENTANILLACLIREP;
DEALLOCATE PREPARE STOPEVENTANILLACLIREP;


END TerminaStore$$