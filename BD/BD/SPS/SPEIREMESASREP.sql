-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIREMESASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIREMESASREP`;
DELIMITER $$


CREATE PROCEDURE `SPEIREMESASREP`(
# =====================================================================================
# ------- STORE PARA PROCESAR LOS REPORTES DE REMESAS SPEI ---------
# =====================================================================================
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_SucursalID			INT(11),
	Par_TipoOperacion       INT(11),
	Par_Estado			    INT(11),

	Par_NivelReporte	    INT(11),
	/* Parámetros de Auditoria */
	Par_EmpresaID       	INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),

	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)

TerminaStore: BEGIN

-- declaracion de constantes
DECLARE Entero_Cero		     INT;
DECLARE Entero_Uno           INT;
DECLARE Rep_Remesas          INT;
DECLARE TipOpe_Todos         INT;
DECLARE TipOpe_Trans         INT;
DECLARE TipOpe_Remes         INT;
DECLARE Esta_Todos           INT;
DECLARE Esta_Corre           INT;
DECLARE Esta_Err             INT;
DECLARE Esta_Pen             INT;
DECLARE Nr_Detalle           INT;
DECLARE Nr_Resumen           INT;
DECLARE Cadena_Vacia	     CHAR(1);
DECLARE EstatusPen           CHAR(1);
DECLARE EstatusCorr          CHAR(1);
DECLARE EstatusErr           CHAR(1);
DECLARE EstatusAut           CHAR(1);
DECLARE Tipo_Remesa          VARCHAR(40);
DECLARE Tipo_Trans           VARCHAR(40);
DECLARE Des_EstatusPen       VARCHAR(40);
DECLARE Des_EstatusCorr      VARCHAR(40);
DECLARE Des_EstatusErr       VARCHAR(40);
DECLARE Des_EstatusAut       VARCHAR(40);

-- Asignacion de constantes
SET   Entero_Cero      := 0;                        -- Entero cero
SET   Entero_Uno       := 1;                        -- Entero uno
SET   Cadena_Vacia     :='';                        -- Cadena vacia
SET   Rep_Remesas  	   := 1;                        -- Reporte de remesas
SET   TipOpe_Todos     := 1;                        -- Tipo de operacion todos
SET   TipOpe_Trans     := 2;                        -- Tipo de operacion Transferencias internas
SET   TipOpe_Remes     := 3;                        -- Tipo de operacion enviosspei
SET   Esta_Todos       := 1;                        -- Estados todos
SET   Esta_Corre       := 2;                        -- Estados correcto
SET   Esta_Err         := 3;                        -- Estados erroneo
SET   Esta_Pen         := 4;                        -- Estados Pendientes
SET   Nr_Detalle       := 2;                        -- Nivel del reporte a detalle
SET   Nr_Resumen       := 1;                        -- Nivel de reporte resumen
SET   EstatusPen       := 'P';                      -- Estatus Pendiente por Autorizar
SET   EstatusCorr      := 'E';                      -- Estatus Enviada Remesa
SET   EstatusErr       := 'E';                      -- Estatus Error en Carga Remesa
SET   EstatusAut       := 'A';                      -- Estatus Autorizado Transferencias
SET   Tipo_Remesa      :='ENVIOS SPEI';             -- Descripcion Operacion Remesa
SET   Tipo_Trans       :='TRANSFERENCIAS INTERNAS'; -- Descripcion Operacion Transferencia
SET   Des_EstatusPen   :='PENDIENTE POR AUTORIZAR'; -- Descripcion Estatus P
SET   Des_EstatusCorr  :='ENVIADA';                 -- Descripcion Estatus E
SET   Des_EstatusErr   :='ERROR EN CARGA';          -- Descripcion Estatus E
SET   Des_EstatusAut   :='AUTORIZADA';              -- Descripcion Estatus A


CREATE TEMPORARY TABLE TMPREPREM(
	Fecha             DATE,
	TipoOperacion     VARCHAR(40),
	Procesados        INT,
	Pendientes        INT,
	Errores           INT,
	Correctos         INT,
	Monto             DECIMAL(16,2)
);

CREATE TEMPORARY TABLE TMPREPDET(
	Fecha                DATE,
	CuentaOrigen         VARCHAR(40),
	CuentaBeneficiario   VARCHAR(40),
	Monto                DECIMAL(16,2),
	Estatus              VARCHAR(40),
	TipoOperacion        VARCHAR(40),
	NombreBeneficiario   VARCHAR(100),
	MensajeError		 VARCHAR(250),
	ClaveRastreo		 VARCHAR(30),
	UsuarioEnvio		 VARCHAR(30),
	Sucursal			 VARCHAR(100)
);

-- NIVEL DE REPORTE RESUMEN DE LAS REMESAS --
IF(Par_NivelReporte = Nr_Resumen AND Par_TipoOperacion = TipOpe_Remes)THEN

	INSERT INTO TMPREPREM (Fecha, TipoOperacion, Procesados, Pendientes, Correctos, Errores, Monto)

	(SELECT DATE(Rem.FechaRecepcion) AS Fecha, Tipo_Remesa, Entero_Cero,
	  SUM(CASE Rem.Estatus
			   WHEN EstatusPen THEN Entero_Uno
					ELSE Entero_Cero END) AS Pendientes,
	  SUM(CASE Rem.Estatus
			   WHEN EstatusCorr THEN Entero_Uno
					ELSE Entero_Cero END) AS Correctas,
	  Entero_Cero,
	  SUM(CONVERT(FNDECRYPTSAFI(Rem.MontoTransferir), DECIMAL(16,2)))
	  FROM SPEIREMESAS AS Rem
	  WHERE DATE(Rem.FechaRecepcion) >=DATE(Par_FechaInicio)
		AND DATE(Rem.FechaRecepcion) <=DATE(Par_FechaFin)
	  GROUP BY DATE(Rem.FechaRecepcion))

	  UNION

	  (SELECT DATE(Des.FechaDescarga) AS Fecha, Tipo_Remesa,Entero_Cero,
	  Entero_Cero,Entero_Cero,
	  SUM(CASE Des.Estatus
			   WHEN EstatusErr THEN Entero_Uno
					ELSE Entero_Cero END) AS Errores,
	  SUM(CONVERT(FNDECRYPTSAFI(Des.MontoTransferir), DECIMAL(16,2)))
	  FROM SPEIDESCARGASREM AS Des
	  WHERE  Des.Estatus=EstatusErr
	  AND DATE(Des.FechaDescarga)  >=DATE(Par_FechaInicio)
	  AND DATE(Des.FechaDescarga) <=DATE(Par_FechaFin)
	  GROUP BY DATE(Des.FechaDescarga));

	  SELECT Fecha, TipoOperacion, SUM(Pendientes+Errores+Correctos) AS Procesados, SUM(Pendientes) AS Pendientes,
	  SUM(Errores) AS Errores, SUM(Correctos) AS Correctos, FORMAT(SUM(Monto),2) AS Monto
	  FROM TMPREPREM
	  GROUP BY Fecha, TipoOperacion;


	  END IF;

-- NIVEL DE REPORTE RESUMEN DE LAS TRANSFERENCIAS --
IF(Par_NivelReporte = Nr_Resumen AND Par_TipoOperacion = TipOpe_Trans)THEN

	INSERT INTO TMPREPREM (Fecha, TipoOperacion, Procesados, Pendientes, Correctos, Errores, Monto)

	SELECT DATE(Tran.FechaAlta) AS Fecha, Tipo_Trans, Entero_Cero,
	  SUM(CASE Tran.Estatus
			   WHEN EstatusPen THEN Entero_Uno
					ELSE Entero_Cero END) AS Pendientes,
	  SUM(CASE Tran.Estatus
			   WHEN EstatusAut THEN Entero_Uno
					ELSE Entero_Cero END) AS Correctas,
	  Entero_Cero,
	  SUM(Tran.Monto)
	  FROM SPEITRANSFERENCIAS AS Tran
	  WHERE DATE(Tran.FechaAlta) >=DATE(Par_FechaInicio) AND DATE(Tran.FechaAlta) <=DATE(Par_FechaFin)
	  GROUP BY DATE(Tran.FechaAlta);


	  SELECT Fecha, TipoOperacion, SUM(Pendientes+Errores+Correctos) AS Procesados, SUM(Pendientes) AS Pendientes,
	  SUM(Errores) AS Errores, SUM(Correctos) AS Correctos, FORMAT(SUM(Monto),2) AS Monto
	  FROM TMPREPREM
	  GROUP BY Fecha, TipoOperacion;


END IF;


-- NIVEL DE REPORTE RESUMEN REMESAS + TRANSFERENCIAS --
IF(Par_NivelReporte = Nr_Resumen AND Par_TipoOperacion = TipOpe_Todos)THEN
	INSERT INTO TMPREPREM (Fecha,		TipoOperacion,	Procesados,	Pendientes,	Correctos,
							Errores,	Monto)
		(SELECT DATE(Rem.FechaRecepcion) AS Fecha, Tipo_Remesa, Entero_Cero,
			SUM(CASE Rem.Estatus
				   WHEN EstatusPen THEN Entero_Uno
						ELSE Entero_Cero END) AS Pendientes,
			SUM(CASE Rem.Estatus
				   WHEN EstatusCorr THEN Entero_Uno
						ELSE Entero_Cero END) AS Correctas,
			Entero_Cero,
			SUM(CONVERT(FNDECRYPTSAFI(Rem.MontoTransferir), DECIMAL(16,2)))
		FROM SPEIREMESAS AS Rem
		WHERE DATE(Rem.FechaRecepcion) >=DATE(Par_FechaInicio)
		  AND DATE(Rem.FechaRecepcion) <=DATE(Par_FechaFin)
		GROUP BY DATE(Rem.FechaRecepcion))

	UNION

	(SELECT DATE(Des.FechaDescarga) AS Fecha, Tipo_Remesa,Entero_Cero,
	Entero_Cero,Entero_Cero,
	SUM(CASE Des.Estatus
		   WHEN EstatusErr THEN Entero_Uno
				ELSE Entero_Cero END) AS Errores,
	SUM(CONVERT(FNDECRYPTSAFI(Des.MontoTransferir), DECIMAL(16,2)))
	FROM SPEIDESCARGASREM AS Des
	WHERE  Des.Estatus=EstatusErr
	  AND DATE(Des.FechaDescarga) >= DATE(Par_FechaInicio)
	  AND DATE(Des.FechaDescarga) <= DATE(Par_FechaFin)
	GROUP BY DATE(Des.FechaDescarga))

	UNION

	(SELECT DATE(Tran.FechaAlta) AS Fecha, Tipo_Trans, Entero_Cero,
	SUM(CASE Tran.Estatus
		   WHEN EstatusPen THEN Entero_Uno
				ELSE Entero_Cero END) AS Pendientes,
	SUM(CASE Tran.Estatus
		   WHEN EstatusAut THEN Entero_Uno
				ELSE Entero_Cero END) AS Correctas,
	Entero_Cero,
	SUM(Tran.Monto)
	FROM SPEITRANSFERENCIAS AS Tran
	WHERE DATE(Tran.FechaAlta) >= DATE(Par_FechaInicio)
	  AND DATE(Tran.FechaAlta) <= DATE(Par_FechaFin)
	GROUP BY DATE(Tran.FechaAlta));

	SELECT Fecha, TipoOperacion, SUM(Pendientes+Errores+Correctos) AS Procesados, SUM(Pendientes) AS Pendientes,
		SUM(Errores) AS Errores, SUM(Correctos) AS Correctos, FORMAT(SUM(Monto),2) AS Monto
	FROM TMPREPREM
	GROUP BY Fecha, TipoOperacion;

END IF;

-- NIVEL DE REPORTE DETALLADO + REMESAS --
IF(Par_NivelReporte = Nr_Detalle AND Par_TipoOperacion = TipOpe_Remes)THEN

	INSERT INTO TMPREPDET (	Fecha, 		CuentaOrigen, 		CuentaBeneficiario,	Monto,			TipoOperacion,
							Estatus,	NombreBeneficiario, MensajeError,		ClaveRastreo,	UsuarioEnvio,
							Sucursal)
		(SELECT DATE(Rem.FechaRecepcion) AS Fecha, LEFT(FNDECRYPTSAFI(Rem.CuentaOrd),40) AS CuentaOrigen,
			LEFT(FNDECRYPTSAFI(Rem.CuentaBeneficiario),40) AS CuentaBeneficiario,
			CONVERT(FNDECRYPTSAFI(Rem.MontoTransferir), DECIMAL(16,2)) AS Monto, Tipo_Remesa,
			CASE Rem.Estatus
			  WHEN EstatusPen  THEN  Des_EstatusPen
			  WHEN EstatusCorr THEN  Des_EstatusCorr
			END Estatus, LEFT(FNDECRYPTSAFI(Rem.NombreBeneficiario),100) AS NombreBeneficiario, Cadena_Vacia,
			ClaveRastreo,
			UsuarioEnvio,
			SucursalOpera
		FROM SPEIREMESAS AS Rem
		WHERE DATE(Rem.FechaRecepcion) >= DATE(Par_FechaInicio)
		  AND DATE(Rem.FechaRecepcion) <= DATE(Par_FechaFin)
		  AND (Rem.Estatus=EstatusPen
			OR Rem.Estatus=EstatusCorr))

		UNION ALL

		(SELECT DATE(Des.FechaDescarga) AS Fecha, LEFT(FNDECRYPTSAFI(Des.CuentaOrd),40) AS CuentaOrigen,
			LEFT(FNDECRYPTSAFI(Des.CuentaBeneficiario),40) AS CuentaBeneficiario,
			CONVERT(FNDECRYPTSAFI(Des.MontoTransferir), DECIMAL(16,2)) AS Monto, Tipo_Remesa,
			CASE Des.Estatus
			  WHEN EstatusErr THEN Des_EstatusErr
				END Estatus, LEFT(FNDECRYPTSAFI(Des.NombreBeneficiario),100) AS NombreBeneficiario, MenError,
			ClaveRastreo,
			UsuarioEnvio,
			SucursalOpera
			FROM SPEIDESCARGASREM AS Des
			WHERE  Des.Estatus=EstatusErr
			  AND DATE(Des.FechaDescarga) >= DATE(Par_FechaInicio)
			  AND DATE(Des.FechaDescarga) <= DATE(Par_FechaFin));

	UPDATE TMPREPDET TMP
		INNER JOIN SUCURSALES SUC ON TMP.Sucursal = SUC.SucursalID
	SET TMP.Sucursal	= SUC.NombreSucurs;

	 -- PARA TODOS
	IF(Par_Estado = Esta_Todos) THEN

		SELECT Fecha, CuentaOrigen, CuentaBeneficiario, FORMAT(Monto,2) AS Monto,  Estatus, TipoOperacion, NombreBeneficiario
			FROM TMPREPDET
		ORDER BY Fecha;

	END IF;

	-- PARA CORRECTOS
	IF(Par_Estado = Esta_Corre) THEN

		SELECT	Fecha, 			CuentaOrigen, CuentaBeneficiario, FORMAT(Monto,2) AS Monto,  Estatus,
				TipoOperacion,	NombreBeneficiario
		FROM TMPREPDET
		WHERE	Estatus	= Des_EstatusCorr
		ORDER BY Fecha;

	END IF;

	  -- PARA ERRORES
	IF(Par_Estado = Esta_Err) THEN
		SELECT	Fecha,			CuentaOrigen,	CuentaBeneficiario,	FORMAT(Monto,2) AS Monto, 	MensajeError AS Estatus,
				TipoOperacion,	NombreBeneficiario
		FROM TMPREPDET
		WHERE	Estatus	= Des_EstatusErr
		ORDER BY Fecha;

	END IF;

	-- PARA PENDIENTES
	IF(Par_Estado = Esta_Pen) THEN
		SELECT Fecha, CuentaOrigen, CuentaBeneficiario, FORMAT(Monto,2) AS Monto,  Estatus,
				TipoOperacion,NombreBeneficiario
		FROM TMPREPDET
		WHERE Estatus	= Des_EstatusPen
		ORDER BY Fecha;

	END IF;

END IF;

-- NIVEL DE REPORTE DETALLADO + TRANSFERENCIAS --
IF(Par_NivelReporte = Nr_Detalle AND Par_TipoOperacion = TipOpe_Trans)THEN
	INSERT INTO TMPREPDET (	Fecha, CuentaOrigen, CuentaBeneficiario, Monto,TipoOperacion,Estatus,NombreBeneficiario,
							ClaveRastreo, UsuarioEnvio, Sucursal)

		SELECT DATE(Tran.FechaAlta) AS Fecha, Cadena_Vacia AS CuentaOrigen,Tran.ClabeCli AS CuentaBeneficiario,
		Tran.Monto AS Monto, Tipo_Trans,
		CASE Tran.Estatus
		  WHEN EstatusPen  THEN  Des_EstatusPen
		  WHEN EstatusAut  THEN  Des_EstatusAut
		END Estatus, Tran.NombreCli AS NombreBeneficiario,
		Cadena_Vacia AS ClaveRastreo,
		Cadena_Vacia AS UsuarioEnvio,
		Cadena_Vacia AS Sucursal
		FROM SPEITRANSFERENCIAS AS Tran
		WHERE DATE(Tran.FechaAlta) >= DATE(Par_FechaInicio)
		  AND DATE(Tran.FechaAlta) <= DATE(Par_FechaFin)
		  AND (Tran.Estatus	= EstatusPen
			OR Tran.Estatus	= EstatusAut);

	-- PARA TODOS
	IF(Par_Estado = Esta_Todos) THEN

		SELECT	Fecha,			CuentaOrigen,		CuentaBeneficiario,		FORMAT(Monto,2) AS Monto,	Estatus,
				TipoOperacion,	NombreBeneficiario,	ClaveRastreo,			UsuarioEnvio,				Sucursal
		FROM TMPREPDET
		ORDER BY Fecha;

	END IF;

	-- PARA CORRECTOS
	IF(Par_Estado = Esta_Corre) THEN
		SELECT	Fecha, 			CuentaOrigen,		CuentaBeneficiario,		FORMAT(Monto,2) AS Monto,	Estatus,
				TipoOperacion,	NombreBeneficiario,	ClaveRastreo,			UsuarioEnvio,				Sucursal
		FROM TMPREPDET
		WHERE Estatus	= Des_EstatusAut
		ORDER BY Fecha;

	END IF;

	-- PARA PENDIENTES
	IF(Par_Estado = Esta_Pen) THEN
		SELECT	Fecha, 			CuentaOrigen,		CuentaBeneficiario,		FORMAT(Monto,2) AS Monto,	Estatus,
				TipoOperacion,	NombreBeneficiario,	ClaveRastreo,			UsuarioEnvio,				Sucursal
		FROM TMPREPDET
		WHERE Estatus	= Des_EstatusPen
		ORDER BY Fecha;
	END IF;
END IF;

-- NIVEL DE REPORTE DETALLADO + REMESAS + TRANSFERENCIAS --
IF(Par_NivelReporte = Nr_Detalle AND Par_TipoOperacion = TipOpe_Todos) THEN
	  INSERT INTO TMPREPDET (Fecha, CuentaOrigen, 		CuentaBeneficiario, Monto,			TipoOperacion,
							Estatus,NombreBeneficiario, MensajeError,		ClaveRastreo,	UsuarioEnvio,
							Sucursal)

		  SELECT DATE(Rem.FechaRecepcion) AS Fecha, LEFT(FNDECRYPTSAFI(Rem.CuentaOrd),40) AS CuentaOrigen,LEFT(FNDECRYPTSAFI(Rem.CuentaBeneficiario),40) AS CuentaBeneficiario,
			CONVERT(FNDECRYPTSAFI(Rem.MontoTransferir), DECIMAL(16,2)) AS Monto, Tipo_Remesa,
			CASE Rem.Estatus
			  WHEN EstatusPen  THEN  Des_EstatusPen
			  WHEN EstatusCorr THEN  Des_EstatusCorr
			END Estatus, LEFT(FNDECRYPTSAFI(Rem.NombreBeneficiario),100) AS NombreBeneficiario, Cadena_Vacia,
			ClaveRastreo,
			UsuarioEnvio,
			SucursalOpera
			FROM SPEIREMESAS AS Rem
			WHERE DATE(Rem.FechaRecepcion) >=DATE(Par_FechaInicio)
			  AND DATE(Rem.FechaRecepcion) <=DATE(Par_FechaFin)
			  AND (Rem.Estatus=EstatusPen
					OR Rem.Estatus=EstatusCorr)

			UNION ALL

		 SELECT DATE(Des.FechaDescarga) AS Fecha, LEFT(FNDECRYPTSAFI(Des.CuentaOrd),40) AS CuentaOrigen,
		 	LEFT(FNDECRYPTSAFI(Des.CuentaBeneficiario),40) AS CuentaBeneficiario,
			CONVERT(FNDECRYPTSAFI(Des.MontoTransferir), DECIMAL(16,2)) AS Monto, Tipo_Remesa,
			CASE Des.Estatus
			  WHEN EstatusErr THEN Des_EstatusErr
			END Estatus, LEFT(FNDECRYPTSAFI(Des.NombreBeneficiario),100) AS NombreBeneficiario, MenError,
			ClaveRastreo,
			UsuarioEnvio,
			SucursalOpera
			FROM SPEIDESCARGASREM AS Des
			WHERE  Des.Estatus=EstatusErr
			  AND DATE(Des.FechaDescarga) >= DATE(Par_FechaInicio)
			  AND DATE(Des.FechaDescarga) <= DATE(Par_FechaFin)

			UNION ALL

		 SELECT DATE(Tran.FechaAlta) AS Fecha, Cadena_Vacia AS CuentaOrigen,Tran.ClabeCli AS CuentaBeneficiario,
			Tran.Monto AS Monto, Tipo_Trans,
			CASE Tran.Estatus
			  WHEN EstatusPen  THEN  Des_EstatusPen
			  WHEN EstatusAut THEN  Des_EstatusAut
			END Estatus, Tran.NombreCli AS NombreBeneficiario, Cadena_Vacia,
			Cadena_Vacia AS ClaveRastreo,
			Cadena_Vacia AS UsuarioEnvio,
			Cadena_Vacia AS Sucursal
			FROM SPEITRANSFERENCIAS AS Tran
			WHERE DATE(Tran.FechaAlta) >= DATE(Par_FechaInicio)
			  AND DATE(Tran.FechaAlta) <= DATE(Par_FechaFin)
			  AND (Tran.Estatus=EstatusPen
				OR Tran.Estatus=EstatusAut);

	UPDATE TMPREPDET TMP
		INNER JOIN SUCURSALES SUC ON TMP.Sucursal = SUC.SucursalID
	SET TMP.Sucursal	= SUC.NombreSucurs;

	-- PARA TODOS
	IF(Par_Estado = Esta_Todos) THEN
		SELECT	Fecha, 			CuentaOrigen,			CuentaBeneficiario,		FORMAT(Monto,2) AS Monto,	Estatus,
				TipoOperacion,	NombreBeneficiario,		ClaveRastreo,			UsuarioEnvio,				Sucursal
		FROM TMPREPDET
		ORDER BY Fecha;

	END IF;

	-- PARA CORRECTOS
	IF(Par_Estado = Esta_Corre) THEN

		SELECT	Fecha, 			CuentaOrigen,			CuentaBeneficiario,		FORMAT(Monto,2) AS Monto,	Estatus,
				TipoOperacion,	NombreBeneficiario,		ClaveRastreo,			UsuarioEnvio,				Sucursal
		FROM TMPREPDET
		WHERE Estatus	= Des_EstatusCorr
			OR Estatus	= Des_EstatusAut
		ORDER BY Fecha;
	END IF;

	-- PARA ERRORES
	IF(Par_Estado = Esta_Err) THEN

		SELECT Fecha, 			CuentaOrigen, CuentaBeneficiario, FORMAT(Monto,2) AS Monto,
				CASE WHEN MensajeError <> Cadena_Vacia THEN MensajeError
						ELSE Estatus END AS Estatus,
				TipoOperacion,	NombreBeneficiario,		ClaveRastreo,		UsuarioEnvio,		Sucursal
		FROM TMPREPDET
		WHERE Estatus	= Des_EstatusErr
		ORDER BY Fecha;

	END IF;

	-- PARA PENDIENTES
	IF(Par_Estado = Esta_Pen) THEN

		SELECT	Fecha, 			CuentaOrigen,			CuentaBeneficiario,	FORMAT(Monto,2) AS Monto,	Estatus,
				TipoOperacion,	NombreBeneficiario,		ClaveRastreo,		UsuarioEnvio,				Sucursal
		FROM TMPREPDET
		WHERE Estatus	= Des_EstatusPen
		ORDER BY Fecha;

	END IF;

END IF;

DROP TABLE TMPREPREM;
DROP TABLE TMPREPDET;

END TerminaStore$$