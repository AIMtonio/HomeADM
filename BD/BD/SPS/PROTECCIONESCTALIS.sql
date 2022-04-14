-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROTECCIONESCTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROTECCIONESCTALIS`;DELIMITER $$

CREATE PROCEDURE `PROTECCIONESCTALIS`(

	Par_ClienteID		int(11),
	Par_NumLis			tinyint unsigned,
	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,

	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint	)
TerminaStore: BEGIN


DECLARE Var_EsMenorEdad		char(1);
DECLARE Var_EdadCliente		int(11);
DECLARE Var_CuentaProtec	int(11);
DECLARE Var_CuentaProtecMen	int(11);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Est_Activo			char(1);
DECLARE	Est_Bloquea			char(1);
DECLARE Lis_CtaAsociaCli	int;
DECLARE FechaSis			date;
DECLARE MenorEdad			char(1);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Est_Activo			:= 'A';
Set	Est_Bloquea			:= 'B';
set Lis_CtaAsociaCli	:=2;
set MenorEdad			:= 'S';


if(Par_NumLis = Lis_CtaAsociaCli) then
	set Var_EsMenorEdad  :=(SELECT IFNULL(EsMenorEdad,Cadena_Vacia) FROM CLIENTES WHERE ClienteID = Par_ClienteID LIMIT 1);
	set Var_CuentaProtec := IFNULL((select TipoCtaProtec from PARAMETROSCAJA LIMIT 1),Entero_Cero);
	set Var_CuentaProtecMen := IFNULL((select TipoCtaProtecMen from PARAMETROSCAJA LIMIT 1),Entero_Cero);

		IF(Var_EsMenorEdad = MenorEdad) THEN
			set FechaSis  := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			set Var_EdadCliente  := (Select	(YEAR (FechaSis)- YEAR (FechaNacimiento)) - (RIGHT(FechaSis,5)<RIGHT(FechaNacimiento,5)) AS Edad
										from CLIENTES
										where ClienteID = Par_ClienteID
										limit 1);
				IF EXISTS (SELECT EmpresaID FROM PARAMETROSCAJA
								WHERE EdadMinimaCliMen <= Var_EdadCliente
									AND EdadMaximaCliMen >= Var_EdadCliente) THEN
						 select	CA.CuentaAhoID,	CA.ClienteID,	CA.TipoCuentaID,	TCTA.Descripcion,	format(CA.Saldo,2) as Saldo
							from	PROTECCIONESCTA CA,
									TIPOSCUENTAS TCTA
							  where ClienteID			= Par_ClienteID
								and CA.TipoCuentaID		= TCTA.TipoCuentaID
								and (TCTA.TipoCuentaID	= Var_CuentaProtec
									 or TCTA.TipoCuentaID	= Var_CuentaProtecMen);
				END IF;

		ELSE
			select	CA.CuentaAhoID,	CA.ClienteID,	CA.TipoCuentaID,	TCTA.Descripcion,	format(CA.Saldo,2) as Saldo
					from	PROTECCIONESCTA CA,
							TIPOSCUENTAS TCTA
					  where ClienteID			= Par_ClienteID
						and CA.TipoCuentaID		= TCTA.TipoCuentaID
						and TCTA.TipoCuentaID	= Var_CuentaProtec;
		END IF;

end if;

END TerminaStore$$