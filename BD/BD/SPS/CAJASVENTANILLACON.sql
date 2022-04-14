-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASVENTANILLACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASVENTANILLACON`;
DELIMITER $$

CREATE PROCEDURE `CAJASVENTANILLACON`(
		Par_CajaID			INT,
		Par_SucursalID		INT,
		Par_UsuarioID		INT,
		Par_TipoCaja		CHAR(2),
		Par_NumCon			TINYINT UNSIGNED,

		Aud_EmpresaID		INT,
		Aud_Usuario			INT,
		Aud_FechaActual		DATETIME,
		Aud_DireccionIP		VARCHAR(15),
		Aud_ProgramaID		VARCHAR(50),
		Aud_Sucursal		INT,
		Aud_NumTransaccion	BIGINT
			)
TerminaStore: BEGIN

	DECLARE		Con_Principal		INT;
	DECLARE		Con_Foranea		INT;
	DECLARE		Con_Saldos		INT;
	DECLARE		Con_CajasTransfer 	INT;
	DECLARE		Con_Usuario 		INT;
	DECLARE		Con_Efectivo 		INT;
	DECLARE		Con_CajaPrinEO	INT;
	DECLARE		Con_CajaPrinCA		INT;
	DECLARE		Con_NumTransPendCaj	INT;
	DECLARE		Con_NumTransPendSuc		INT;
	DECLARE		Con_CajaPrincipalSuc	INT(11);			-- COnsultanos la caja principal de la sucursal para el ws de ingreso operaciones
	DECLARE		Cons_Aperturado	CHAR(1);
	DECLARE		Cons_Alta		CHAR(1);
	DECLARE		Cons_Activa		CHAR(1);

	DECLARE		Var_Sentencia 		VARCHAR(750);
	DECLARE		Var_CajaID		INT;
	DECLARE		Entero_Cero		INT;
	DECLARE 	Con_TipoCajas 		INT;
	DECLARE 	Var_Union			VARCHAR(500);
	DECLARE		CadenaVacia		CHAR(1);


	DECLARE		Var_CajaPrincipal	INT;
	DECLARE		Var_EOCaja		CHAR(1);

	SET	Con_CajasTransfer	:= 1;
	SET	Con_Saldos			:= 2;
	SET Con_Principal		:= 3;
	SET Con_Usuario			:= 4;
	SET	Con_Efectivo		:= 5;
	SET	Con_TipoCajas		:= 6;
	SET Con_CajaPrinEO		:= 7;
	SET Con_CajaPrinCA		:= 8;
	SET Con_NumTransPendSuc		:= 9;
	SET Con_NumTransPendCaj		:= 10;
	SET Con_CajaPrincipalSuc	:= 11;			-- COnsultanos la caja principal de la sucursal para el ws de ingreso operaciones
	SET Entero_Cero 		:= 0;
	SET CadenaVacia		:= "";
	SET		Cons_Aperturado	:= 'A';
	SET		Cons_Alta		:= 'A';
	SET		Cons_Activa		:= 'A';
	SET Par_CajaID		:=IFNULL(Par_CajaID, Entero_Cero);
	SET	Par_SucursalID	:=IFNULL(Par_SucursalID, Entero_Cero);

	IF (Par_NumCon = Con_Principal) THEN
		SELECT 	CajaID, 		  TipoCaja, 		SucursalID, 	UsuarioID, 				DescripcionCaja,
				LimiteEfectivoMN, Estatus, 			EstatusOpera,	MotivoCan,				MotivoInac,
				MotivoAct,		  LimiteDesemMN,	MaximoRetiroMN, TipoCaja AS TipoCajaID, NomImpresora,
				NomImpresoraCheq,HuellaDigital
		FROM CAJASVENTANILLA
		WHERE   CajaID = Par_CajaID;
	END IF;

	IF(Par_NumCon = Con_CajasTransfer) THEN
			SELECT CajaID, CASE TipoCaja
				WHEN 'CA' THEN 'CAJA DE ATENCION AL PUBLICO'
				WHEN 'CP' THEN 'CAJA PRINCIPAL DE SUCURSAL'
				WHEN 'BG' THEN 'BOVEDA CENTRAL'
				END AS TipoCaja, SucursalID, UsuarioID, 	DescripcionCaja,
				LimiteEfectivoMN, 		Estatus, 			EstatusOpera, 	MotivoCan,	MotivoInac,
				MotivoAct,			LimiteDesemMN,	MaximoRetiroMN,	TipoCaja AS TipoCajaID,	NomImpresora,
				NomImpresoraCheq,HuellaDigital
			FROM CAJASVENTANILLA
			WHERE  CajaID = Par_CajaID;
	END IF;

	IF(Par_NumCon = Con_TipoCajas) THEN
			SET Var_Sentencia := CONCAT('SELECT CajaID, CASE TipoCaja WHEN "CA" THEN "CAJA DE ATENCION AL PUBLICO"
					WHEN "CP" THEN "CAJA PRINCIPAL DE SUCURSAL"	WHEN "BG" THEN "BOVEDA CENTRAL"
					END AS TipoCaja, SucursalID, UsuarioID, DescripcionCaja, LimiteEfectivoMN,
					Estatus, EstatusOpera,MotivoCan,	MotivoInac, MotivoAct,LimiteDesemMN,MaximoRetiroMN, TipoCaja AS TipoCajaID, NomImpresora, NomImpresoraCheq,HuellaDigital FROM CAJASVENTANILLA WHERE CajaID = ', CONVERT(Par_CajaID,CHAR));

			IF(Par_TipoCaja = "CA")THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND SucursalID = ', CONVERT(Par_SucursalID,CHAR), ' AND TipoCaja != "BG"' );
			END IF;

			IF (Par_TipoCaja = "BG")THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND TipoCaja != "CA";');
			END IF;
			SET @Sentencia	= Var_Sentencia;
			PREPARE STCAJASVENTANILLALIS FROM @Sentencia;
			EXECUTE STCAJASVENTANILLALIS;
			DEALLOCATE PREPARE STCAJASVENTANILLALIS;

	END IF;

	IF(Par_NumCon = Con_Saldos) then
		IF(Par_CajaID=0) then
         SELECT
            0 as SaldoEfecMN,0 as SaldoEfecME,0 as LimiteEfectivoMN,0 as cancela;
        ELSE
		SELECT IFNULL(SaldoEfecMN,0) as SaldoEfecMN, IFNULL(SaldoEfecME,0) as SaldoEfecME, IFNULL(LimiteEfectivoMN,0) as LimiteEfectivoMN,
			CASE WHEN SaldoEfecMN > 0 THEN 1 ELSE 0 END AS cancela
			from CAJASVENTANILLA
			where SucursalID = Par_SucursalID
			and CajaID = Par_CajaID;
        END IF;
	END IF;


	IF(Par_NumCon = Con_Usuario) THEN
			SELECT CajaID, 	TipoCaja, 	SucursalID, UsuarioID, DescripcionCaja,
					LimiteEfectivoMN, 	Estatus,	EstatusOpera,	MotivoCan,	MotivoInac,
					MotivoAct,LimiteDesemMN,MaximoRetiroMN,TipoCaja AS TipoCajaID, NomImpresora,
					NomImpresoraCheq,HuellaDigital
			FROM CAJASVENTANILLA
			WHERE UsuarioID = Par_UsuarioID;
	END IF;

	IF(Par_NumCon = Con_CajaPrinEO)THEN
		IF(SELECT COUNT(CajaID)
			FROM CAJASVENTANILLA
			WHERE 'CP'= TipoCaja
			AND Par_SucursalID = SucursalID
			AND EstatusOpera = Cons_Aperturado
			AND Estatus = Cons_Activa) = 1
		THEN
			SELECT CajaID INTO Var_CajaPrincipal
			FROM CAJASVENTANILLA
			WHERE 'CP'= TipoCaja
			AND Par_SucursalID = SucursalID
			AND EstatusOpera = Cons_Aperturado
			AND Estatus = Cons_Activa ;
		ELSE
			SELECT COUNT(CajaID) INTO Var_CajaPrincipal
			FROM CAJASVENTANILLA
			WHERE 'CP'= TipoCaja
			AND Par_SucursalID = SucursalID
			AND EstatusOpera = Cons_Aperturado
			AND Estatus = Cons_Activa ;
			SET Var_CajaPrincipal := Var_CajaPrincipal * -1;
		 END IF;
		SELECT EstatusOpera INTO Var_EOCaja
			FROM CAJASVENTANILLA
			WHERE Par_CajaID = CajaID
			AND Par_SucursalID = SucursalID
			LIMIT 1;
		SELECT IFNULL(Var_CajaPrincipal,Entero_Cero)  AS CajaID , IFNULL(Var_EOCaja,CadenaVacia) AS EstatusOpera ;
	END IF;

	IF(Par_NumCon = Con_CajaPrinCA)THEN
		SELECT COUNT(CajaID) INTO Var_CajaPrincipal
			FROM CAJASVENTANILLA
			WHERE 'CA'= TipoCaja
			AND Par_SucursalID = SucursalID
			AND EstatusOpera = Cons_Aperturado
			AND Estatus = Cons_Activa
			AND IFNULL(UsuarioID, Entero_Cero) > Entero_Cero;
		SET Var_EOCaja := CadenaVacia;
		SELECT IFNULL(Var_CajaPrincipal,Entero_Cero)  AS CajaID , IFNULL(Var_EOCaja,CadenaVacia) AS EstatusOpera ;
	END IF;
	IF(Par_NumCon = Con_NumTransPendSuc) THEN
		SELECT COUNT( (cv.CajaID)) INTO Var_CajaPrincipal
		FROM CAJASTRANSFER CAJ, CAJASVENTANILLA cv
		WHERE 	CAJ.CajaDestino = cv.CajaID
			AND CAJ.Estatus =  Cons_Alta
			AND CAJ.SucursalOrigen = Par_SucursalID;
		SET Var_EOCaja := CadenaVacia;
		SELECT IFNULL(Var_CajaPrincipal,Entero_Cero)  AS CajaID , IFNULL(Var_EOCaja,CadenaVacia) AS EstatusOpera ;
	END IF;
	IF(Par_NumCon = Con_NumTransPendCaj) THEN
		SELECT COUNT( (cv.CajaID)) INTO Var_CajaPrincipal
		FROM CAJASTRANSFER CAJ, CAJASVENTANILLA cv
		WHERE 	cv.CajaID = Par_CajaID
			AND CAJ.SucursalOrigen = Par_SucursalID
			AND CAJ.CajaDestino = cv.CajaID
			AND CAJ.Estatus = Cons_Alta ;
		SET Var_EOCaja := CadenaVacia;
		SELECT IFNULL(Var_CajaPrincipal,Entero_Cero)  AS CajaID , IFNULL(Var_EOCaja,CadenaVacia) AS EstatusOpera ;
	END IF;

	-- COnsultanos la caja principal de la sucursal para el ws de ingreso operaciones
	IF(Par_NumCon = Con_CajaPrincipalSuc) THEN
		SELECT CajaID,		TipoCaja,	DescripcionCaja
		FROM CAJASVENTANILLA
		WHERE SucursalID = Par_SucursalID
			AND TipoCaja = 'CP'
			LIMIT 1;
	END IF;


	END TerminaStore$$