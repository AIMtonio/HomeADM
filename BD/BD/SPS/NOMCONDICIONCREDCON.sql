DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMCONDICIONCREDCON`;

DELIMITER $$
CREATE PROCEDURE `NOMCONDICIONCREDCON`(
# =====================================================================================
# ------- STORE PARA CONSULTAR LAS CONDICIONES DE PRODUCTOS DE CREDITOS---------
# =====================================================================================
	Par_CondicionCredID		BIGINT(20),		-- Identificador de la condicion
	Par_InstitNominaID		INT(11),		-- Institucion de nomina relacionada con el convenio
	Par_ConvenioNominaID	BIGINT UNSIGNED,-- Convenio con el cual se relaciona el producto de credito
	Par_ProducCreditoID		INT(11),		-- Producto de credito que se relaciona con la nomina y el convenio

	Par_NumConsulta			INT(11),		-- Numero de consulta a realizar

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME, 		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)

TerminaStore:BEGIN
		-- Declaracion de Variables

		-- Declaracion de Constantes
		DECLARE Con_ProdConv	INT(11);	-- Consulta  el producto de credito que tiene un convenio para la nomina.

		DECLARE Entero_Cero		INT(11);
		DECLARE Cadena_Vacia	CHAR(1);
		DECLARE Con_Vigente		CHAR(1);
		DECLARE Con_EsqTasa		INT(1);		-- Consulta si la condicion de credito tiene un esquema tasas
		DECLARE Con_ExisteCond	INT(1);		-- Consulta si existe condicion credito
		DECLARE Con_SolCred     INT(1);     -- Consulta condicion por empresa producto y convenio
		-- Seteo de valores
		SET Con_ProdConv	:= 1;
		SET Con_EsqTasa		:= 2;
		SET Con_ExisteCond	:= 3;
		SET Con_SolCred		:= 4;

		SET Entero_Cero		:=	0;
		SET Cadena_Vacia	:=	'';
		SET Con_Vigente		:= 'V';

		-- Consulta si existe una condicion de credito vigente para el producto de credito de una nomina
		IF (Par_NumConsulta = Con_ProdConv) THEN
			SELECT CondicionCredID, 	ConvenioNominaID, 	InstitNominaID, 		ProducCreditoID,		TipoTasa,
					ValorTasa
			FROM NOMCONDICIONCRED
			WHERE CondicionCredID  = Par_CondicionCredID;

		END IF;

		-- Consulta si existe un esquema de tasas para esta condicion
		IF (Par_NumConsulta = Con_EsqTasa) THEN
			SELECT Count(EsqTasaCredID) AS Cantidad
			FROM NOMESQUEMATASACRED
			WHERE CondicionCredID  = Par_CondicionCredID;

		END IF;

		 -- Consulta si existe un esquema de tasas para esta condicion
		IF (Par_NumConsulta = Con_ExisteCond)THEN
			SELECT IFNULL(COUNT(CondicionCredID),Entero_Cero) AS NCoincidencias
			FROM NOMCONDICIONCRED
			WHERE CondicionCredID  = Par_CondicionCredID;
		END IF;

				 -- Consulta si existe un esquema de tasas para esta condicion
		IF (Par_NumConsulta = Con_SolCred)THEN
			SELECT CondicionCredID, 	ConvenioNominaID, 	InstitNominaID, 		ProducCreditoID,		TipoTasa,
					ValorTasa,			TipoCobMora,		ValorMora
			FROM NOMCONDICIONCRED
			WHERE InstitNominaID  = Par_InstitNominaID
			AND	  ProducCreditoID = Par_ProducCreditoID
			AND   ConvenioNominaID = Par_ConvenioNominaID;
		END IF;

END TerminaStore$$
