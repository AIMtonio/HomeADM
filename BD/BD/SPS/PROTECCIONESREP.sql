-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROTECCIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROTECCIONESREP`;DELIMITER $$

CREATE PROCEDURE `PROTECCIONESREP`(




	Par_ClienteID			INT(11),
	Par_SucursalID			INT(11),
	Par_ClienteCancelaID	INT(11),

	Par_NumRep			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN


DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE Cadena_vacia		CHAR(1);
DECLARE	Rep_Principal		INT;
DECLARE	Rep_SocMenor		INT;



DECLARE Var_Sentencia		VARCHAR(9000);
DECLARE Var_CtaOrdinaria 	INT(11);
DECLARE Var_CtaVista		INT(11);
DECLARE Var_ClienteID		INT(11);
DECLARE Var_NombreCliente	VARCHAR(300);
DECLARE Var_ParteSocial		DECIMAL(14,2);
DECLARE Var_AhorroOrdinario DECIMAL(14,2);
DECLARE Var_IntAhorroOrdinario   DECIMAL(14,2);
DECLARE Var_ISRAhorroOrdinario   DECIMAL(14,2);
DECLARE Var_AhorroVista     	 DECIMAL(14,2);
DECLARE Var_IntAhorroVista 		 DECIMAL(14,2);
DECLARE Var_Inversiones    		 DECIMAL(14,2);
DECLARE Var_IntInversiones    	 DECIMAL(14,2);
DECLARE Var_ISRInversiones 		 DECIMAL(14,2);
DECLARE Var_TotalFiniquito 		 DECIMAL(14,2);
DECLARE Var_Comentarios 		 VARCHAR(500);
DECLARE Var_NombreTutor			 VARCHAR(300);
DECLARE Var_FechaSistema		 DATE;
DECLARE Var_AhorroMenores		 DECIMAL(14,2);
DECLARE Var_IntAhorroMenores	 DECIMAL(14,2);
DECLARE Var_ISRAhorroMenores	 DECIMAL(14,2);
DECLARE Var_SucursalDes			 VARCHAR(100);
DECLARE Var_CobradoPROFUN		 DECIMAL(14,2);



SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.0;
SET Cadena_vacia		:= '';
SET	Rep_Principal		:= 1;
SET Rep_SocMenor		:= 2;


SELECT IFNULL(CtaOrdinaria,Entero_Cero), IFNULL(CuentaVista,Entero_Cero)
 FROM PARAMETROSCAJA
INTO Var_CtaOrdinaria, Var_CtaVista;

SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_SucursalDes		:= (SELECT NombreSucurs	FROM SUCURSALES WHERE SucursalID = Par_SucursalID);


IF(Par_NumRep = Rep_Principal) THEN

		SELECT Pro.ClienteID, Cli.Nombrecompleto, Pro.ParteSocial, Pro.CobradoPROFUN,Can.Comentarios
			FROM PROTECCIONES Pro,
				 CLIENTES Cli,
				 CLIENTESCANCELA Can
			WHERE	Pro.ClienteID =  Cli.ClienteID
				and Can.ClienteID =  Cli.ClienteID
				AND Pro.ClienteID = Par_ClienteID
				AND Can.ClienteCancelaID =Par_ClienteCancelaID

		INTO Var_ClienteID, Var_NombreCliente, Var_ParteSocial, Var_CobradoPROFUN, Var_Comentarios;


		SELECT SUM(Cta.Saldo), SUM(Cta.InteresesCap), SUM(Cta.InteresRetener)
			FROM PROTECCIONESCTA Cta
			WHERE Cta.ClienteID = Par_ClienteID
				AND Cta.TipoCuentaID = Var_CtaOrdinaria
		INTO Var_AhorroOrdinario, Var_IntAhorroOrdinario, Var_ISRAhorroOrdinario;


		SELECT SUM(Cta.Saldo), SUM(Cta.InteresesCap)
			FROM PROTECCIONESCTA Cta
			WHERE Cta.ClienteID = Par_ClienteID
				AND Cta.TipoCuentaID = Var_CtaVista
		INTO Var_AhorroVista, Var_IntAhorroVista;


		SELECT SUM(Inv.Monto), SUM(Inv.InteresGenerado), SUM(Inv.InteresRetener)
			FROM PROTECCIONESINV Inv
			WHERE Inv.ClienteID = Par_ClienteID
		INTO Var_Inversiones, Var_IntInversiones, Var_ISRInversiones;

		set Var_ParteSocial			:= ifnull(Var_ParteSocial, Decimal_Cero);
		set Var_AhorroOrdinario		:= ifnull(Var_AhorroOrdinario, Decimal_Cero);
		set Var_IntAhorroOrdinario	:= ifnull(Var_IntAhorroOrdinario, Decimal_Cero);
		set Var_ISRAhorroOrdinario	:= ifnull(Var_ISRAhorroOrdinario, Decimal_Cero);
		set Var_AhorroVista			:= ifnull(Var_AhorroVista, Decimal_Cero);
		set Var_IntAhorroVista 		:= ifnull(Var_IntAhorroVista, Decimal_Cero);
		set Var_Inversiones 		:= ifnull(Var_Inversiones, Decimal_Cero);
		set Var_IntInversiones		:= ifnull(Var_IntInversiones, Decimal_Cero);
		set Var_ISRInversiones		:= ifnull(Var_ISRInversiones, Decimal_Cero);
		set Var_CobradoPROFUN		:= ifnull(Var_CobradoPROFUN, Decimal_Cero);

		SET Var_TotalFiniquito  := (Var_ParteSocial + Var_AhorroOrdinario + Var_IntAhorroOrdinario +
								Var_AhorroVista + Var_IntAhorroVista + Var_Inversiones + Var_IntInversiones )
									-
								(Var_ISRAhorroOrdinario + Var_ISRInversiones + Var_CobradoPROFUN);


		SELECT Var_ClienteID 			AS ClienteID,
			   Var_NombreCliente 		AS NombreCliente,
			   Var_ParteSocial  		AS ParteSocial,
			   Var_AhorroOrdinario  	AS AhorroOrdinario,
			   Var_IntAhorroOrdinario 	AS IntAhorroOrdinario,
			   Var_ISRAhorroOrdinario 	AS ISRAhorroOrdinario,
			   Var_AhorroVista 			AS AhorroVista,
			   Var_IntAhorroVista 		AS IntAhorroVista,
			   Var_Inversiones 			AS Inversiones,
			   Var_IntInversiones 		AS IntInversiones,
			   Var_ISRInversiones 		AS ISRInversiones,
			   Var_TotalFiniquito		AS Totalfiniquito,
			   Var_Comentarios 			AS Comentarios,
			   Var_NombreTutor			AS NombreTutor,
			   Var_FechaSistema			AS FechaSistema,
			   Var_SucursalDes			AS Sucursal,
			   Var_CobradoPROFUN		AS CobradoPROFUN;
END IF;



IF(Par_NumRep = Rep_SocMenor) THEN
			SELECT Cli.ClienteID, Cli.Nombrecompleto,  Can.Comentarios
			FROM CLIENTES Cli,
				 CLIENTESCANCELA Can
			WHERE	Can.ClienteID =  Cli.ClienteID
				AND Cli.ClienteID = Par_ClienteID
		INTO Var_ClienteID, Var_NombreCliente, Var_Comentarios;

	SET Var_NombreTutor := (SELECT NombreTutor
		FROM SOCIOMENOR
		WHERE SocioMenorID = Par_ClienteID
			AND ClienteTutorID = Entero_Cero);

	IF(IFNULL(Var_NombreTutor,Cadena_Vacia) = Cadena_Vacia) THEN
		SELECT Cli.Nombrecompleto
			FROM CLIENTES Cli,
				 SOCIOMENOR Soc
			WHERE Cli.ClienteID = Soc.ClienteTutorID
				AND Soc.SocioMenorID = Par_ClienteID
		INTO Var_NombreTutor;
	END IF;

	SELECT TotalSaldoOriCap,	InteresCap,					InteresRetener,				TotalHaberes
		FROM PROTECCIONES
		WHERE ClienteId = Par_ClienteID
	INTO Var_AhorroMenores,		Var_IntAhorroMenores,		Var_ISRAhorroMenores,		Var_TotalFiniquito;

	SET Var_AhorroMenores			:= IFNULL(Var_AhorroMenores, Decimal_Cero);
	SET Var_IntAhorroMenores		:= IFNULL(Var_IntAhorroMenores, Decimal_Cero);
	SET Var_ISRAhorroMenores		:= IFNULL(Var_ISRAhorroMenores, Decimal_Cero);
	SET Var_TotalFiniquito			:= IFNULL(Var_TotalFiniquito, Decimal_Cero);


	SELECT Var_ClienteID 			AS ClienteID,
			   Var_NombreCliente 		AS NombreCliente,
			   Var_AhorroMenores		AS AhorroMenores,
			   Var_IntAhorroMenores		AS IntAhorroMenores,
			   Var_ISRAhorroMenores		AS ISRAhorroMenores,
			   Var_TotalFiniquito		AS Totalfiniquito,
			   Var_Comentarios 			AS Comentarios,
			   Var_NombreTutor			AS NombreTutor,
			   Var_FechaSistema			AS FechaSistema,
			   Var_SucursalDes			AS Sucursal;

END IF;


END TerminaStore$$