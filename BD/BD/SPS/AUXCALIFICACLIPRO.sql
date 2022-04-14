-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AUXCALIFICACLIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `AUXCALIFICACLIPRO`;DELIMITER $$

CREATE PROCEDURE `AUXCALIFICACLIPRO`(




	INOUT Par_InteresPromGen		DOUBLE,
	INOUT Par_TotalClientes			INT,
	INOUT Par_SaldoPromGen			DOUBLE,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN



DECLARE Var_FechaSis		DATE;
DECLARE Tiempo_Atras		DATE;
DECLARE Var_InteresOrdi		DOUBLE;
DECLARE Var_InteresAtra		DOUBLE;
DECLARE Var_InteresVen		DOUBLE;


DECLARE Estatus_Activo		CHAR(1);



SET Estatus_Activo		:='A';


SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);


	ManejoErrores:BEGIN


		SET Par_TotalClientes := (SELECT COUNT(ClienteID)
							FROM CLIENTES
							WHERE Estatus = Estatus_Activo);


		SET Par_SaldoPromGen := (SELECT SUM(Cue.Saldo)
							FROM CUENTASAHO Cue,
								PARAMETROSCAJA Par,
								CLIENTES Cli
							WHERE Cli.ClienteID = Cue.ClienteID AND Cli.Estatus = Estatus_Activo AND Cue.Estatus = Estatus_Activo
							AND Cue.TipoCuentaID = Par.CtaOrdinaria);

		SET Par_SaldoPromGen := (Par_SaldoPromGen / Par_TotalClientes) / 2;


		SET Tiempo_Atras  := (SELECT DATE_SUB(Var_FechaSis, INTERVAL 3 YEAR));
		SELECT SUM(Det.MontoIntOrd), SUM(Det.MontoIntAtr), SUM(Det.MontoIntVen)
						FROM CLIENTES Cli,
							 CREDITOS Cre,
							 DETALLEPAGCRE  Det
						WHERE Cli.Estatus = Estatus_Activo
						AND Cli.ClienteID = Cre.ClienteID
						AND Cre.CreditoID = Det.CreditoID
						AND Cre.FechaInicio BETWEEN Tiempo_Atras AND Var_FechaSis
		INTO Var_InteresOrdi, Var_InteresAtra, Var_InteresVen;
		SET Par_InteresPromGen  := ((Var_InteresOrdi + Var_InteresAtra + Var_InteresVen) / Par_TotalClientes) /2;


	END ManejoErrores;
END TerminaStore$$