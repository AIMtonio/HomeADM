-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSANTGASTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSANTGASTOSLIS`;
DELIMITER $$


CREATE PROCEDURE `TIPOSANTGASTOSLIS`(

	Par_TipoAntGastoID			varchar(50),
	Par_Naturaleza				char(1),
	Par_NumLis					int(11),

	Par_EmpresaID				int(11),
	Aud_Usuario					int(11),
	Aud_FechaActual				datetime,
	Aud_DireccionIP				varchar(15),
	Aud_ProgramaID				varchar(50),
	Aud_Sucursal				varchar(50),
	Aud_NumTransaccion			bigint
	)

TerminaStore: BEGIN


DECLARE Entero_Cero				int(11);
DECLARE Cadena_Vacia			char(1);
DECLARE Fecha_Vacia				date;
DECLARE Lis_Principal			int(11);
DECLARE Lis_Foranea				int(11);
DECLARE Salida_Efect			char(1);
DECLARE Entrada_Efect			char(1);
DECLARE Desc_EntradaEfect		varchar(20);
DECLARE Desc_SalidaEfect		varchar(20);
DECLARE Lis_Combo				int(11);
DECLARE Lis_ComboEntrada		int(11);
DECLARE Lis_NaturalezaEntrada	int(11);
DECLARE Lis_PrincipalApp		INT(11);		-- Consulta que devuelve la lista de gastos y anticipos para la bancamovil

SET Entero_Cero					:= 0;
SET Cadena_Vacia				:='';
SET Fecha_Vacia					:='1900-01-01';
SET Lis_Principal				:= 1;
SET Lis_Foranea					:= 2;
SET Lis_Combo					:= 3;
SET Lis_ComboEntrada			:= 4;
SET Lis_NaturalezaEntrada		:= 5;
SET Lis_PrincipalApp			:= 6;			-- Consulta que devuelve la lista de gastos y anticipos para la bancamovil
SET Salida_Efect				:='S';
SET Entrada_Efect				:='E';
SET Desc_EntradaEfect			:="ENTRADA EFECTIVO";
SET Desc_SalidaEfect			:="SALIDA EFECTIVO";

IF(Par_NumLis = Lis_Principal)then
		SELECT TipoAntGastoID,	Descripcion, case Naturaleza
													when Salida_Efect then Desc_SalidaEfect
													when Entrada_Efect then Desc_EntradaEfect END as Naturaleza
			FROM TIPOSANTGASTOS
				where Descripcion like concat("%", Par_TipoAntGastoID, "%")
		limit  15 ;

END IF;

IF(Par_NumLis=Lis_Combo)THEN
	SELECT TipoAntGastoID,Descripcion
			FROM TIPOSANTGASTOS
				where Naturaleza=Salida_Efect
				 and Estatus="A";
END IF;
IF(Par_NumLis=Lis_ComboEntrada)THEN
	SELECT TipoAntGastoID,Descripcion
			FROM TIPOSANTGASTOS
				where Naturaleza=Entrada_Efect
				and Estatus="A";
END IF;


IF(Par_NumLis = Lis_NaturalezaEntrada)then
			SELECT TipoAntGastoID,	Descripcion, case Naturaleza
														when Salida_Efect then Desc_SalidaEfect
														when Entrada_Efect then Desc_EntradaEfect END as Naturaleza
				FROM TIPOSANTGASTOS
					where Descripcion like concat("%", Par_TipoAntGastoID, "%")
						and Naturaleza=Par_Naturaleza
			limit  15 ;
END IF;

IF(Par_NumLis = Lis_PrincipalApp)then
		SELECT 	TipoAntGastoID,		Descripcion,		Estatus,			EsGastoTeso, 			TipoGastoID,
				ReqNoEmp,			CtaContable,		CentroCosto,			Instrumento,			MontoMaxEfect,
				MontoMaxTrans,		case Naturaleza
													when Salida_Efect then Desc_SalidaEfect
													when Entrada_Efect then Desc_EntradaEfect END as Naturaleza
				
			FROM TIPOSANTGASTOS;
END IF;
END TerminaStore$$
