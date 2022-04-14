-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOLIS`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOLIS`(
-- -------------------------------------------------------------------
-- 			SP PARA LISTAS DE CUENTAS DE AHORRO
-- -------------------------------------------------------------------
	Par_NombreComp		VARCHAR(50),		-- Nombre del cliente
	Par_ClienteID		INT(11),			-- Numero de Cliente
	Par_InstitucionID 	INT(11),			-- Numero de institucion
	Par_TipoCuenta		VARCHAR(10),		-- Tipo de cuenta
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

    -- Parametros de Auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

	#Declaracion de  variables
	DECLARE Var_Sentencia 				VARCHAR(4000);
    DECLARE Var_ClienteInst				INT(11);

	#Declaracion de constantes
	DECLARE	Cadena_Vacia				CHAR(1);
	DECLARE	Fecha_Vacia					DATE;
	DECLARE	Entero_Cero					INT(11);
	DECLARE	Est_Activo					CHAR(1);
	DECLARE	Est_Inactivo				CHAR(1);

    DECLARE	Est_Bloquea					CHAR(1);
	DECLARE Est_Cancelada      			CHAR(1);
	DECLARE Est_DepReg	     			INT(11);      		-- Estatus registrado Uno

	DECLARE	Lis_Principal 				INT(11);
	DECLARE	Lis_Ctas_Cte 				INT(11);
	DECLARE	Lis_Num_Cte 				INT(11);
	DECLARE	Lis_ResumenCte 				INT(11);
	DECLARE Lis_PrincipalAlfa			INT(11);

    DECLARE Lis_ClabeCte 				INT(1);
	DECLARE	Lis_ResumCteActivas 		INT(11);
	DECLARE	Lis_CtasCte 				INT(11);
	DECLARE Lis_CtaAhoWS				INT(11);
	DECLARE Lis_CtasAsociacion			INT(11);

	DECLARE Lis_IngOpera				INT(11);  # lista para pantalla de ingresos operaciones
	DECLARE Lis_IngOperaSuc				INT(11);
	DECLARE Lis_PorTipoCta				INT(11);
	DECLARE Lis_IngOperaVen 			INT(11);
	DECLARE Lis_AplicaDocSBC			INT(11);

	DECLARE Lis_CtaCliente				INT(11);
    DECLARE Lis_CtaActivaCte			INT(11);
    DECLARE Lis_GuardaValores			INT(11);
    DECLARE Lis_CtasConTarjetas 		INT(11);
    DECLARE Lis_ComPendienteSalProm 	INT(11);
	DECLARE Lis_CuentasActivas		 	INT(11);
    DECLARE Lis_CtasDepositoActiva INT(11);


    /*ASIGNACION DE CONSTANTES*/
	SET	Cadena_Vacia			:=	'';
	SET	Fecha_Vacia				:=	'1900-01-01';
	SET	Entero_Cero				:=	0;
	SET	Est_Activo				:=	'A';
	SET	Est_Inactivo			:=	'I';

	SET	Est_Bloquea				:=	'B';
	SET Est_Cancelada			:=	'C';
	SET Est_DepReg          	:= 1;

	SET	Lis_Principal			:=	1;
	SET	Lis_Num_Cte				:=	2;
	SET	Lis_Ctas_Cte			:=	3;
	SET	Lis_ResumenCte			:=	4;
	SET	Lis_ClabeCte 			:=	5;

	SET Lis_PrincipalAlfa		:=	6;
	SET	Lis_ResumCteActivas		:=	8;
	SET	Lis_CtasCte 			:=	9;
	SET Lis_CtaAhoWS            :=	11;	-- Lista de Cuenta Ahorro Destino WS
    SET Lis_CtasAsociacion		:=	12;	-- Lista para Pantalla de Asociacion de Tarjetas

	SET Lis_IngOpera			:=	13;
	SET Lis_PorTipoCta			:=	14;  -- Lista que filtra por cliente y Tipo de Cta
	SET Lis_IngOperaSuc			:=	15;
	SET Lis_IngOperaVen			:=	16;
    SET Lis_AplicaDocSBC		:=	17;	-- Lista que se ocupa en la pantalla Aplicacion de Documento SBC en Ventanilla

	SET Lis_CtaCliente 			:=	19; --  Lista para obtener las cuentas de los Clientes
    SET Lis_CtaActivaCte		:= 20;	--  Lista todas las cuentas activas de un cliente
    SET Lis_GuardaValores		:= 21;	-- Lista de Guarda Valores
	SET Lis_CtasConTarjetas     := 22;  -- Lista las tarjetas que cuentas con tarjetas de debito.
	SET Lis_ComPendienteSalProm	:= 23;	-- Lista de comision pendiente de saldo promedio

	SET Lis_CuentasActivas		:= 24;	-- Lista de cuentas activas
	SET Lis_CtasDepositoActiva  := 25;  -- Lista las cuentas  que requieren un deposito para activacion

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	Cu.CuentaAhoID,	Cl.NombreCompleto
			FROM CUENTASAHO Cu,	CLIENTES Cl
			WHERE	Cl.NombreCompleto	LIKE CONCAT("%", Par_NombreComp, "%")
			AND	Cu.ClienteID= Cl.ClienteID
			LIMIT 0, 15;
	END IF;


	IF(Par_NumLis = Lis_PrincipalAlfa) THEN
		SELECT	Cu.CuentaAhoID,	Cl.NombreCompleto
			FROM CUENTASAHO Cu,	CLIENTES Cl
			WHERE	(Cl.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			OR 	Cu.CuentaAhoID LIKE CONCAT( Par_NombreComp, "%"))
			AND	Cu.ClienteID= Cl.ClienteID
			LIMIT 0, 15;
	END IF;


	IF(Par_NumLis = Lis_Num_Cte) THEN
		SELECT 	CA.CuentaAhoID,  TC.Descripcion
			FROM CUENTASAHO	CA,	TIPOSCUENTAS TC
			WHERE	CA.TipoCuentaID	=	TC.TipoCuentaID
			AND	CA.ClienteID	=	Par_ClienteID
			AND	CA.Estatus	= 	Est_Activo
			LIMIT 0, 15;
	END IF;

	/* muestra todas las cuentas del cliente excepto canceladas*/
	IF(Par_NumLis = Lis_CtasCte) THEN
		SELECT	CA.CuentaAhoID,	TC.Descripcion
			FROM CUENTASAHO	CA,	TIPOSCUENTAS	TC
			WHERE	CA.TipoCuentaID	=	TC.TipoCuentaID
			AND	CA.ClienteID	=	Par_ClienteID
			AND	CA.Estatus	<>	Est_Cancelada
			LIMIT 0, 15;
	END IF;


	IF(Par_NumLis = Lis_Ctas_Cte) THEN
		SELECT	CA.CuentaAhoID,	CTE.NombreCompleto,	TC.Descripcion
			FROM CUENTASAHO	CA
			INNER JOIN	TIPOSCUENTAS	TC	ON	CA.TipoCuentaID	=	TC.TipoCuentaID
			INNER JOIN	CLIENTES	CTE	ON	CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%")	AND	CTE.Estatus!='I'
			AND	CA.ClienteID	=	CTE.ClienteID
			AND	CA.Estatus	<>	Est_Cancelada
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_ResumenCte) THEN
		SELECT	CA.CuentaAhoID,	IFNULL(TC.Descripcion,"")	AS	TipoCuentaID,	CA.Etiqueta,
			IFNULL(FORMAT(CA.Saldo,2), 0.00) AS Saldo, IFNULL(FORMAT(CA.SaldoDispon,2),0.00) AS SaldoDispon,
			IFNULL(FORMAT(CA.SaldoBloq,2),0.00) AS SaldoBloq,   IFNULL(FORMAT(CA.SaldoSBC,2),0.00) AS SaldoSBC,	CA.Estatus
			FROM CUENTASAHO CA,	TIPOSCUENTAS TC
			WHERE	CA.ClienteID	=	Par_ClienteID
			AND	CA.TipoCuentaID	=	TC.TipoCuentaID
			AND	(CA.Estatus	=	Est_Activo
			OR	CA.Estatus	=	Est_Bloquea)
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_ClabeCte) THEN
		SELECT	CA.Clabe,	CTE.NombreCompleto
			FROM CUENTASAHO	CA,	(SELECT	ClienteID,	NombreCompleto
			FROM CLIENTES
			WHERE	NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%"))	AS	CTE
			WHERE	CA.InstitucionID	=	Par_InstitucionID
			AND	CA.ClienteID	=	CTE.ClienteID
			AND	CA.Estatus	<>	Est_Cancelada
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_ResumCteActivas) THEN
		SELECT	CA.CuentaAhoID,	TC.Descripcion	AS	TipoCuentaID,
				CA.Etiqueta,	CA.Saldo,	CA.SaldoDispon,	CA.SaldoBloq,
				CA.SaldoSBC,	CA.Estatus
			FROM CUENTASAHO CA,	TIPOSCUENTAS TC
			WHERE	CA.ClienteID	=	Par_ClienteID
			AND	CA.TipoCuentaID	=	TC.TipoCuentaID
			AND	CA.Estatus	=	Est_Activo
			LIMIT 0, 200;
	END IF;

	IF(Par_NumLis = Lis_ResumCteActivas) THEN
		SELECT  Cuentaid,Descripcion,Saldo
			FROM TIPOSCUENTAS AS tip
			INNER JOIN CUENTASAHO AS cho ON tip.TipoCuentaID= cho.TipoCuentaID
			INNER JOIN CREDITOS AS c ON c.CuentaID=cho.CuentaAhoID
			WHERE EsBloqueoAuto= 'S'	AND Saldo>0	AND (c.Estatus= 'I' OR c.Estatus= 'A' OR c.Estatus='P')
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_CtaAhoWS) THEN
		SELECT	Ca.CuentaAhoID, Cli.NombreCompleto
			FROM CUENTASAHO Ca
			INNER JOIN CLIENTES Cli ON Ca.ClienteID = Cli.ClienteID
			INNER JOIN TIPOSCUENTAS Tc ON Ca.TipoCuentaID = Tc.TipoCuentaID  	AND  Cli.NombreCompleto LIKE CONCAT("%",Par_NombreComp, "%")
			WHERE	Ca.Estatus		<>	Est_Cancelada
			LIMIT 0, 15;
	END IF;

	-- Lista para pantalla Asociacion Tarjetas
	IF (Par_NumLis = Lis_CtasAsociacion) THEN
		SELECT	CA.CuentaAhoID,	CTE.NombreCompleto, TC.Descripcion
			FROM CUENTASAHO	CA
			INNER JOIN TIPOSCUENTAS	TC	ON	CA.TipoCuentaID	=	TC.TipoCuentaID
			INNER JOIN CLIENTES CTE	ON	CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%") AND CTE.Estatus!='I'
			AND	CA.ClienteID	=	CTE.ClienteID
			WHERE	CA.Estatus = Est_Activo AND TC.TipoCuentaID IN (SELECT TipoCuentaID FROM TIPOSCUENTATARDEB WHERE TipoTarjetaDebID = Par_TipoCuenta )
			LIMIT 0, 15;
	END IF;

	# No. 13, Utilizada en pantalla de Ingresos Operaciones
	IF(Par_NumLis = Lis_IngOpera) THEN
		IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
			SELECT	CA.CuentaAhoID,	CTE.ClienteID,	CTE.NombreCompleto,
					TC.Descripcion,	SUC.NombreSucurs,	CTE.FechaNacimiento
				FROM CUENTASAHO	CA, TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC
				WHERE  CA.TipoCuentaID = TC.TipoCuentaID
					AND	CA.ClienteID	=	CTE.ClienteID
					AND CTE.SucursalOrigen	=	SUC.SucursalID
					AND CTE.ClienteID	=	Par_ClienteID
					AND CTE.Estatus	=	Est_Activo
					AND CA.Estatus	=	Est_Activo
					LIMIT 0, 15;
		ELSE
			SELECT 	CA.CuentaAhoID,		CTE.ClienteID,		 CTE.NombreCompleto,	 TC.Descripcion,
					SUC.NombreSucurs, CTE.FechaNacimiento
				FROM  CUENTASAHO CA,	TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC
				WHERE  CA.TipoCuentaID = TC.TipoCuentaID
					AND	CA.ClienteID	=	CTE.ClienteID
					AND CTE.SucursalOrigen = SUC.SucursalID
					AND CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%")
					AND CTE.Estatus = Est_Activo
					AND CA.Estatus = Est_Activo
					LIMIT 0, 15;
		END IF;
	END IF;

	IF(Par_NumLis = Lis_IngOperaVen) THEN
		IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
			SELECT 	CA.CuentaAhoID,		CTE.ClienteID,		 CTE.NombreCompleto,
					TC.Descripcion,		SUC.NombreSucurs, CTE.FechaNacimiento
				FROM CUENTASAHO CA,	TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC
				WHERE	CA.TipoCuentaID = TC.TipoCuentaID
					AND	CA.ClienteID	=	CTE.ClienteID
					AND CTE.SucursalOrigen = SUC.SucursalID
					AND CTE.ClienteID = Par_ClienteID
					AND CTE.Estatus = Est_Activo
					AND CA.Estatus = Est_Activo
					ORDER BY CTE.NombreCompleto
					LIMIT 0, 50;
		ELSE
			SELECT 	CA.CuentaAhoID,		CTE.ClienteID,		 CTE.NombreCompleto,	 TC.Descripcion,
					SUC.NombreSucurs, CTE.FechaNacimiento
				FROM CUENTASAHO CA,	TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC
				WHERE	CA.TipoCuentaID	=	TC.TipoCuentaID
					AND	CA.ClienteID	=	CTE.ClienteID
					AND CTE.SucursalOrigen	=	SUC.SucursalID
					AND CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%")
					AND CTE.Estatus	=	Est_Activo
					AND CA.Estatus	=	Est_Activo
					ORDER BY CTE.NombreCompleto
					LIMIT 0, 50;
		END IF;
	END IF;


	IF(Par_NumLis = Lis_IngOperaSuc) THEN
		IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero)THEN
			SELECT 	CA.CuentaAhoID,		CTE.ClienteID,		 CTE.NombreCompleto,
					TC.Descripcion,		SUC.NombreSucurs, CTE.FechaNacimiento
				FROM CUENTASAHO CA,	TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC
				WHERE	CA.TipoCuentaID	=	TC.TipoCuentaID
					AND	CA.ClienteID	=	CTE.ClienteID
					AND CTE.SucursalOrigen	=	SUC.SucursalID
					AND CTE.ClienteID	=	Par_ClienteID
					AND CTE.Estatus	=	Est_Activo
					AND CA.Estatus	=	Est_Activo
					ORDER BY CTE.NombreCompleto
					LIMIT 0, 25;
		ELSE
			SELECT 	CA.CuentaAhoID,		CTE.ClienteID,		 CTE.NombreCompleto,	 TC.Descripcion,
					SUC.NombreSucurs, CTE.FechaNacimiento
				FROM  CUENTASAHO CA,	TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC
				WHERE  CA.TipoCuentaID	=	TC.TipoCuentaID
					AND	CA.ClienteID	=	CTE.ClienteID
					AND CTE.SucursalOrigen	=	SUC.SucursalID
					AND CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%")
					AND CTE.Estatus	=	Est_Activo
					AND CA.Estatus	=	Est_Activo
					AND CTE.SucursalOrigen	=	Aud_Sucursal
					ORDER BY CTE.NombreCompleto
					LIMIT 0, 25;
		END IF;
	END IF;


	IF(Par_NumLis = Lis_PorTipoCta) THEN
		SET Var_Sentencia := '
			SELECT 	CA.CuentaAhoID,  TC.Descripcion
				FROM		CUENTASAHO 		CA
							INNER JOIN TIPOSCUENTAS 	TC ON TC.TipoCuentaID=CA.TipoCuentaID
							INNER JOIN CLIENTES Cli ON Cli.ClienteID=CA.ClienteID
				WHERE		CA.TipoCuentaID	=	TC.TipoCuentaID ';
			SET Var_Sentencia := CONCAT(Var_Sentencia,'AND Cli.NombreCompleto LIKE CONCAT("%",');
			SET Var_Sentencia := CONCAT(Var_Sentencia,'"',Par_NombreComp,'"');
			SET Var_Sentencia := CONCAT(Var_Sentencia,',"%")');
			SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);

			IF(Par_ClienteID != Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND	CA.ClienteID	=', Par_ClienteID);
			END IF;

			SET Var_Sentencia := CONCAT(Var_sentencia,' AND 		CA.Estatus		= "A" ');
			SET Par_TipoCuenta := IFNULL(Par_TipoCuenta, Entero_Cero);

			IF(Par_TipoCuenta != Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND 		TC.TipoCuentaID 	=', Par_TipoCuenta);
			END IF;

			SET Par_InstitucionID := IFNULL(Par_InstitucionID, Entero_Cero);

			IF(Par_InstitucionID > Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND CA.SucursalID		=', Par_InstitucionID);
			END IF;

			SET Var_Sentencia := CONCAT(Var_sentencia,' LIMIT 0, 15 ; ');
			SET @Sentencia	:= (Var_Sentencia);
			PREPARE AHORROLISTA FROM @Sentencia;
			EXECUTE AHORROLISTA;
			DEALLOCATE PREPARE AHORROLISTA;
	END IF;



	# No. 17, Utilizada en pantalla de Aplicacion de Documento SBC en Ventanilla
	IF(Par_NumLis = Lis_AplicaDocSBC) THEN
			IF IFNULL(Par_ClienteID,Entero_Cero) >Entero_Cero  THEN
				SELECT DISTINCT	CA.CuentaAhoID,		CTE.ClienteID,		 CTE.NombreCompleto,	 TC.Descripcion,
					SUC.NombreSucurs, CTE.FechaNacimiento
					FROM CUENTASAHO CA,	TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC,	ABONOCHEQUESBC ABC
					WHERE  CTE.ClienteID=Par_ClienteID
						AND CA.TipoCuentaID = TC.TipoCuentaID
						AND	CA.ClienteID	=	CTE.ClienteID
						AND CTE.SucursalOrigen = SUC.SucursalID
						AND CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%")
						AND CTE.Estatus = Est_Activo
						AND CA.Estatus = Est_Activo
						AND (ABC.CuentaAhoID = CA.CuentaAhoID AND 	ABC.Estatus = "R")
						LIMIT 0, 15;
			ELSE
				SELECT DISTINCT	CA.CuentaAhoID,		CTE.ClienteID,		 CTE.NombreCompleto,	 TC.Descripcion,
					SUC.NombreSucurs, CTE.FechaNacimiento
					FROM CUENTASAHO CA,	TIPOSCUENTAS TC,	CLIENTES CTE,	SUCURSALES SUC,	ABONOCHEQUESBC ABC
					WHERE 	CA.TipoCuentaID	=	TC.TipoCuentaID
						AND	CA.ClienteID	=	CTE.ClienteID
						AND CTE.SucursalOrigen = SUC.SucursalID
						AND CTE.NombreCompleto	LIKE	CONCAT("%", Par_NombreComp, "%")
						AND CTE.Estatus = Est_Activo
						AND CA.Estatus = Est_Activo
						AND (ABC.CuentaAhoID = CA.CuentaAhoID AND 	ABC.Estatus = "R")
						LIMIT 0, 15;
			END IF;
	END IF;


	-- Utilizado para mostrar las cuentas del cliente sin mostrar las cuentas institucionales

	IF(Par_NumLis = Lis_CtaCliente) THEN
		SELECT ClienteInstitucion INTO Var_ClienteInst
			FROM PARAMETROSSIS;
			SET Var_Sentencia := CONCAT('
			SELECT 	CA.CuentaAhoID,  TC.Descripcion
			FROM		CUENTASAHO 		CA
						INNER JOIN TIPOSCUENTAS 	TC ON TC.TipoCuentaID=CA.TipoCuentaID
						INNER JOIN CLIENTES Cli ON Cli.ClienteID=CA.ClienteID
			WHERE	CA.TipoCuentaID NOT IN (SELECT TipoCuentaID FROM CUENTASAHO WHERE ClienteID = ',Var_ClienteInst,
			' GROUP BY TipoCuentaID) AND CA.TipoCuentaID	=	TC.TipoCuentaID ');
			SET Var_Sentencia := CONCAT(Var_Sentencia,'AND Cli.NombreCompleto LIKE CONCAT("%",');
			SET Var_Sentencia := CONCAT(Var_Sentencia,'"',Par_NombreComp,'"');
			SET Var_Sentencia := CONCAT(Var_Sentencia,',"%")');
			SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);

			IF(Par_ClienteID != Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND	CA.ClienteID	=', Par_ClienteID);
			END IF;

            SET Var_Sentencia := CONCAT(Var_sentencia,' AND 		CA.Estatus		= "A" ');
			SET Par_TipoCuenta := IFNULL(Par_TipoCuenta, Entero_Cero);

			IF(Par_TipoCuenta != Entero_Cero)THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND 		TC.TipoCuentaID 	=', Par_TipoCuenta);
			END IF;


			SET Par_InstitucionID := IFNULL(Par_InstitucionID, Entero_Cero);

            IF(Par_InstitucionID > Entero_Cero)THEN
				SET Var_Sentencia	:=	CONCAT(Var_sentencia,' AND CA.SucursalID		=', Par_InstitucionID);
			END IF;
			SET Var_Sentencia	:=	CONCAT(Var_sentencia,' LIMIT 0, 15 ; ');

			SET @Sentencia	:=	(Var_Sentencia);

			PREPARE AHORROLISTA FROM @Sentencia;
			EXECUTE AHORROLISTA;
			DEALLOCATE PREPARE AHORROLISTA;
	END IF;
    IF(Par_NumLis = Lis_CtaActivaCte) THEN
		SELECT 	CA.CuentaAhoID, CA.SaldoDispon AS Saldo, TC.Descripcion
			FROM CUENTASAHO	CA,	TIPOSCUENTAS TC
			WHERE	CA.TipoCuentaID	=	TC.TipoCuentaID
			AND	CA.ClienteID	=	Par_ClienteID
			AND	CA.Estatus	= 	Est_Activo
			LIMIT 0, 15;
	END IF;

	-- Consulta de Guarda Valores
	IF(Par_NumLis = Lis_GuardaValores) THEN
		SELECT CA.CuentaAhoID,	CTE.NombreCompleto,	TC.Descripcion
		FROM CUENTASAHO	CA
		INNER JOIN TIPOSCUENTAS	TC ON CA.TipoCuentaID = TC.TipoCuentaID
		INNER JOIN CLIENTES	CTE	ON CA.ClienteID = CTE.ClienteID
		WHERE CTE.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		LIMIT 0, 15;
	END IF;

		-- Consulta cuentas con tarjetas
	IF(Par_NumLis = Lis_CtasConTarjetas) THEN
		SELECT CA.CuentaAhoID,	Tc.Descripcion
		FROM CUENTASAHO	CA
		INNER JOIN TARJETADEBITO TB ON CA.CuentaAhoID = TB.CuentaAhoID
		INNER JOIN CLIENTES	CTE	ON CA.ClienteID = CTE.ClienteID
		INNER JOIN TIPOSCUENTAS Tc ON CA.TipoCuentaID = Tc.TipoCuentaID
		WHERE  CTE.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		AND CA.Estatus = Est_Activo
		LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_ComPendienteSalProm) THEN
		SELECT 	IFNULL(CO.CuentaAhoID, "") AS CuentaAhoID,	MAX(IFNULL(Tc.Descripcion, '')) AS DescripcionTipoCta,
				MAX(IFNULL(CA.SaldoDispon, 0)) AS SaldoDispon,
				(SUM(IFNULL(CO.ComSaldoPromAct, 0))+SUM(IFNULL(CO.IVAComSalPromAct, 0))) AS SaldoPendiente
		FROM COMSALDOPROMPEND CO
		INNER JOIN CUENTASAHO	CA ON CA.CuentaAhoID=CO.CuentaAhoID
		INNER JOIN TIPOSCUENTAS Tc ON CA.TipoCuentaID = Tc.TipoCuentaID
		INNER JOIN CLIENTES CLI ON CLI.ClienteID= CA.ClienteID
		WHERE   CA.Estatus = Est_Activo
		AND CLI.ClienteID=Par_ClienteID
		GROUP BY CLI.ClienteID, CO.CuentaAhoID;
	END IF;

	IF(Par_NumLis = Lis_CuentasActivas) THEN
		SELECT	Cu.CuentaAhoID,	Cl.NombreCompleto
			FROM CUENTASAHO Cu
			INNER JOIN CLIENTES Cl ON Cu.ClienteID= Cl.ClienteID
			WHERE	Cl.NombreCompleto	LIKE CONCAT('%', Par_NombreComp, '%')
			AND	Cu.Estatus="A"
			LIMIT 0, 15;
	END IF;

    -- 23- lista de cuentas que requieren un deposito para activacion
	IF(Par_NumLis = Lis_CtasDepositoActiva) THEN
		SELECT	Cu.CuentaAhoID,	Cl.NombreCompleto,	De.MontoDepositoActiva
		FROM CUENTASAHO Cu
			INNER JOIN CLIENTES Cl
				ON Cu.ClienteID= Cl.ClienteID
			INNER JOIN DEPOSITOACTIVACTAAHO De
				ON Cu.CuentaAhoID = De.CuentaAhoID
		WHERE De.Estatus = Est_DepReg
			AND De.TipoRegistroCta = 'N'
			AND (Cl.NombreCompleto	LIKE CONCAT("%", Par_NombreComp, "%")
				OR Cu.CuentaAhoID	LIKE CONCAT("%", Par_NombreComp, "%"))
		LIMIT 0, 15;
	END IF;

END TerminaStore$$