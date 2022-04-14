-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPASCALCTASAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASCALCTASAPRO`;
DELIMITER $$


CREATE PROCEDURE `CREPASCALCTASAPRO`(

	Par_CreditoFondeoID	int(11),
	Par_FormulaID 		int(11) ,
	Par_TasaFija 		DECIMAL(12,4),
	Par_EmpresaID		int(11),
	inout Par_TasaOut		Decimal(12,4),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,

	Aud_NumTransaccion	bigint
	)

BEGIN


DECLARE	Var_PisoTasa		DECIMAL(12,4);
DECLARE	Var_TechoTasa		DECIMAL(12,4);
DECLARE	Var_TasaBase		int;
DECLARE	Var_SobreTasa		DECIMAL(12,4);
DECLARE	Var_FecTas			DateTime;
DECLARE	Var_FechaSis		Date;
DECLARE Var_CliProEsp   	INT(10);			-- Almacena el Numero de Cliente para Procesos Especificos
DECLARE Var_EsClientVINGUA		INT(10);			-- Identificador grupo de cliente MEXI
DECLARE Var_EsClientREGIO		INT(10);			-- Identificador grupo de cliente MEXI
DECLARE Var_EsClientPREVICREM	INT(10);			-- Identificador grupo de cliente MEXI
DECLARE Var_EsClientMAAKELAR	INT(10);			-- Identificador grupo de cliente MEXI


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	For_TasaFija		int;
DECLARE	For_BasePuntos		int;
DECLARE	For_BaPunPisTecho	int;
DECLARE For_BaMesAnt		INT(11);
DECLARE	Est_Vigente			char(1);
DECLARE Con_CliProcEspe     VARCHAR(20);					-- Numero de Cliente para Procesos Especificos

Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set	For_TasaFija			:= 1;
Set	For_BasePuntos			:= 2;
Set	For_BaPunPisTecho		:= 3;
Set	For_BaMesAnt			:= 4;
Set	Est_Vigente				:= 'N';
Set Var_FechaSis			:= (select FechaSistema from PARAMETROSSIS);
SET Con_CliProcEspe     	:= 'CliProcEspecifico'; 		-- Numero de Cliente para Procesos Especificos
SET Var_EsClientVINGUA		:= 38;
SET Var_EsClientREGIO		:= 39;
SET Var_EsClientPREVICREM	:= 40;
SET Var_EsClientMAAKELAR	:= 41;

if (Par_FormulaID = For_TasaFija) then
	SET Par_TasaOut = Par_TasaFija ;
elseif (Par_FormulaID = For_BasePuntos) then
	-- Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);

	set Var_TasaBase := (select TasaBase
		from CREDITOFONDEO
		where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_SobreTasa := (select  SobreTasa
		from CREDITOFONDEO
		where CreditoFondeoID	= Par_CreditoFondeoID);

	IF (Var_CliProEsp IN (Var_EsClientVINGUA,Var_EsClientREGIO,Var_EsClientPREVICREM,Var_EsClientMAAKELAR))THEN
		SET Var_FecTas := Var_FechaSis;

		SELECT  	Valor
			INTO 	Par_TasaOut
			FROM TASASBASE
			WHERE TasaBaseID = Var_TasaBase;


		IF(IFNULL(Par_TasaOut, Entero_Cero) = Entero_Cero) THEN
			SET Par_TasaOut := (SELECT  Valor
				FROM `HIS-TASASBASE`
				WHERE TasaBaseID = Var_TasaBase
				AND Fecha <= Var_FecTas
				ORDER BY Fecha DESC, NumTransaccion DESC
				LIMIT 1
			);
		END IF;

	ELSE
		set	Var_FecTas =  (select min(fechaInicio) from AMORTIZAFONDEO
						where CreditoFondeoID = Par_CreditoFondeoID
							and Estatus = Est_Vigente
							and FechaInicio<=Var_FechaSis );

		set	Var_FecTas = ifnull(Var_FecTas, Fecha_Vacia);

		Set Par_TasaOut := (select  max(Valor)
			from `HIS-TASASBASE`
			where TasaBaseID = Var_TasaBase
			  and Fecha	    = Var_FecTas);
	END IF;

	set	Par_TasaOut := ifnull(Par_TasaOut, Entero_Cero);

	set	Par_TasaOut := Par_TasaOut + Var_SobreTasa;
elseif (Par_FormulaID = For_BaPunPisTecho) then
	set Var_TasaBase := (select 	TasaBase
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_SobreTasa := (select 	SobreTasa
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_PisoTasa := (select 	PisoTasa
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_TechoTasa := (select TechoTasa
							from CREDITOFONDEO
							where CreditoFondeoID	= Par_CreditoFondeoID);

	set Var_FecTas := (select  max(Fecha) from `HIS-TASASBASE` where TasaBaseID = Var_TasaBase);

	set	Var_FecTas = ifnull(Var_FecTas, Fecha_Vacia);

	set Par_TasaOut := (select  max(Valor)
							from `HIS-TASASBASE`
							where TasaBaseID = Var_TasaBase
							  and Fecha	    = Var_FecTas);

	set	Par_TasaOut = ifnull(Par_TasaOut, Entero_Cero);
	set	Par_TasaOut = Par_TasaOut + Var_SobreTasa;

	if (Par_TasaOut > Var_TechoTasa) then
		set	Par_TasaOut = Var_TechoTasa;
	end if;

	if (Par_TasaOut < Var_PisoTasa) then
		set	Par_TasaOut := Var_PisoTasa;
	end if;
elseif (Par_FormulaID = For_BaMesAnt) then
	SET Var_TasaBase := (SELECT TasaBase
	FROM CREDITOFONDEO
	WHERE CreditoFondeoID	= Par_CreditoFondeoID);

	SET Var_SobreTasa := (SELECT  SobreTasa
		FROM CREDITOFONDEO
		WHERE CreditoFondeoID	= Par_CreditoFondeoID);
	
	SET Var_FecTas := LAST_DAY(DATE_SUB(Var_FechaSis, INTERVAL 1 MONTH));
	
	SET Par_TasaOut := (
		SELECT Valor
			FROM `HIS-TASASBASE`
			WHERE TasaBaseID = Var_TasaBase
			AND Fecha <= Var_FecTas
			ORDER BY Fecha DESC, NumTransaccion DESC
			LIMIT 1
	);


	SET	Par_TasaOut := IFNULL(Par_TasaOut, Entero_Cero);

	SET	Par_TasaOut := Par_TasaOut + Var_SobreTasa;
ELSE
	SET Par_TasaOut := Entero_Cero;
END IF;

END$$
