-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONCON`;DELIMITER $$

CREATE PROCEDURE `INVERSIONCON`(
/*SP para consultar informacion de una inversion en especifico*/
	Par_InversionID		    INT,				-- inversion a consultar
	Par_TipoConsulta	    INT,				-- tipo de consulta que regresara
	/*Parametros de Audtitoria*/
    Par_UsuarioID		    INT,
	Par_EmpresaID		    INT,
	Par_Fecha				DATE,

	Par_DireccionIP		    VARCHAR(15),
	Par_ProgramaID		    VARCHAR(50),
	Par_Sucursal			INT,
	Par_NumeroTransaccion	BIGINT
)
TerminaStore: BEGIN

	/*declaracion de variables*/
	DECLARE	Var_InversionID		INT;				-- id de la inversion que se consulta
	/*declaracion de constantes*/
	DECLARE Entero_Cero			INT;
	DECLARE	FechaActual			DATE;
	DECLARE FechaInversion		DATE;
	DECLARE ConsultaPrincipal	INT;
	DECLARE ConsultaSecundaria	INT;
	DECLARE ConReporte			INT;
	DECLARE ControlNoticia		VARCHAR(1);
	DECLARE ConVecim_Anticipada	INT;
    DECLARE ReinverC			VARCHAR(10);
    DECLARE ReinverCI			VARCHAR(10);
    DECLARE ReinverN			VARCHAR(10);
	DECLARE MenReinverC			VARCHAR(50);
    DECLARE MenReinverCI		VARCHAR(50);
    DECLARE MenReinverN			VARCHAR(50);
    DECLARE Entero_Diez			INT;
    DECLARE Entero_Once			INT;
    DECLARE Entero_Tres			INT;
    DECLARE Entero_Dos			INT;
    DECLARE Entero_Cuatro		INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Esta_Activo			CHAR(1);
	DECLARE Var_EstatusISR		CHAR(1);

	/*Asignacion de constantes*/
	SET Var_InversionID			:= 0;					-- inversion
	SET Entero_Cero				:= 0;					-- constante cero
    SET Entero_Diez				:= 10;					-- constante diez
    SET Entero_Once				:= 11;					-- constante once
    SET Entero_Tres				:= 3;					-- constante tres
    SET Entero_Dos				:= 2;					-- constante dos
    SET Entero_Cuatro			:= 4;					-- constante cuatro
	SET FechaActual				:= (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID=1);-- obtenemos la fecah actual
	SET ConsultaPrincipal		:= 1;					-- tipo de consulta que  se realizara
	SET ConReporte				:= 2;					-- tipo de consulta que  se realizara
	SET ConVecim_Anticipada		:= 3;					-- tipo de consulta que  se realizara
	SET ControlNoticia			:= '0';					-- variable de control
    SET ReinverC				:= 'C';					-- constante reinversion con capital
    SET ReinverCI				:= 'CI';				-- constante reinversion con capital + interes
    SET ReinverN				:= 'C';					-- constante reinversion no
    SET	MenReinverC				:= 'SOLO CAPITAL';		-- mensaje a mostrar si es reinversion con capital
    SET	MenReinverCI			:= 'CAPITAL MAS INTERES';-- mensaje a mostrar si es reinversion con capital + interes
    SET	MenReinverN				:= 'NO APLICA';			-- mensaje a mostrar si es reinversion no
    SET	Cadena_Vacia			:= '';					-- CADENA VACIA
    SET	Esta_Activo				:= 'A';					-- ESTATUS ACTIVO



    IF(Par_TipoConsulta = ConsultaPrincipal)THEN

		SET Var_EstatusISR := (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
		SET Var_EstatusISR := IFNULL(Var_EstatusISR, Cadena_Vacia);

		SELECT	InversionID,		CuentaAhoID,		TipoInversionID,	FechaInicio,		FechaVencimiento,
				Monto,				Plazo,				Tasa,				TasaISR,			TasaNeta,
				InteresGenerado,
				InteresRecibir,
				IF(Var_EstatusISR = Esta_Activo, FNISRINFOCAL(Monto, Plazo, (TasaISR*100)), InteresRetener) AS InteresRetener,
				Reinvertir,
				Estatus,
				ClienteID,			MonedaID,			Etiqueta,			ValorGat,			Beneficiario,
				CASE Reinvertir	WHEN ReinverC	THEN MenReinverC
								WHEN ReinverCI	THEN MenReinverCI
								WHEN ReinverN	THEN MenReinverN
								ELSE Reinvertir END AS ReinvertirDes,
				ValorGatReal,	Var_EstatusISR AS EstatusISR
			FROM INVERSIONES
				WHERE InversionID = Par_InversionID;

	END IF;

	IF(Par_TipoConsulta = ConReporte) THEN
		SELECT	LPAD(CONVERT(InversionID, CHAR),Entero_Diez,Entero_Cero) AS InversionID,
				NombreCompleto AS NombreCliente,
				LPAD(CONVERT(Suc.SucursalID, CHAR), Entero_Tres,Entero_Cero) AS SucursalID,
				NombreSucurs AS Sucursal,
				LPAD(CONVERT(Inv.CuentaAhoID, CHAR),Entero_Once, Entero_Cero) AS CuentaAho,
				Tii.Descripcion  AS Inversion,
				Inv.Reinvertir AS TipoInversion,
				Mon.Descripcion AS TipoMoneda,
				FechaInicio, FechaVencimiento,
				FORMAT(Monto, Entero_Dos) AS Monto,
				CONVERT(Plazo,CHAR) AS Plazo,
				CONVERT(Tasa, CHAR) AS Tasa,
				CONVERT(Inv.TasaISR,CHAR) AS TasaISR,
				CONVERT(FORMAT(TasaNeta,Entero_Cuatro), CHAR) AS TasaNeta,
				FORMAT(InteresGenerado, Entero_Cuatro) AS InteresGenerado,
				CONVERT(FORMAT(InteresRecibir, Entero_Dos), CHAR) AS InteresRecibir,
				Inv.InteresRetener  AS InteresRetener,
				FORMAT((Monto + InteresRecibir), Entero_Dos) AS totalFinal
			FROM 	INVERSIONES Inv,
					SUCURSALES Suc,
					CATINVERSION Tii,
					MONEDAS Mon,
					CLIENTES Cli
				WHERE Inv.InversionID		= Par_InversionID
				  AND Suc.SucursalID		= Inv.Sucursal
				  AND	Inv.TipoInversionID	= Tii.TipoInversionID
				  AND	Inv.MonedaID		= Mon.MonedaId
				  AND	Inv.ClienteID		= Cli.ClienteID;


	END IF;
	IF(Par_TipoConsulta = ConVecim_Anticipada)THEN

		SELECT  InversionID,
				CuentaAhoID,
                LPAD(CONVERT(TipoInversionID, CHAR),Entero_Diez,Entero_Cero) AS TipoInversionID,
				FechaInicio,
                FechaVencimiento,
                Monto,				Plazo,       	Tasa,			TasaISR,		TasaNeta,
                InteresGenerado,	InteresRecibir,	0,				Reinvertir,		Estatus,
                LPAD(CONVERT(ClienteID, CHAR),Entero_Diez,Entero_Cero) AS ClienteID,
                MonedaID,
			    Etiqueta,
                SaldoProvision,
                DATEDIFF(FechaActual,FechaInicio) AS DiasTrans
			FROM INVERSIONES
				WHERE InversionID = Par_InversionID;

	END IF;

END TerminaStore$$