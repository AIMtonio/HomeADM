-- BANESQACCESORIOSPRODLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANESQACCESORIOSPRODLIS`;
DELIMITER $$

CREATE PROCEDURE `BANESQACCESORIOSPRODLIS`(
# =====================================================================================
# ----- SP QUE LISTA LOS ACCESORIOS COBRADOS POR PRODUCTO DE CREDITO  -----------------
# =====================================================================================
	Par_ProducCreditoID 	INT(11),			# Producto de Credito
    Par_ClienteID			INT(11),			# Numero de Cliente
    Par_MontoCredito		DECIMAL(14,2),		# Monto de Credito
    Par_PlazoID				INT(11),			# Plazo
	Par_AccesorioID			INT(11),			# Accesorio
	Par_InstitNominaID		INT(11),			# Institucion Nomina
	Par_ConvenioID			INT(11),			# Numero de Convenio
	Par_TipoLista			TINYINT UNSIGNED,	# Tipo de Lista

	# Parametros de Auditoria
	Aud_EmpresaID 		INT(11),
	Aud_Usuario 		INT(11),
  	Aud_FechaActual 	DATETIME,
  	Aud_DireccionIP 	VARCHAR(15),
  	Aud_ProgramaID 		VARCHAR(50),
  	Aud_Sucursal 		INT(11),
  	Aud_NumTransaccion 	BIGINT(20)
)
TerminaStore:BEGIN

	CALL ESQACCESORIOSPRODLIS(
		Par_ProducCreditoID,			Par_ClienteID,					Par_MontoCredito,			Par_PlazoID,				Par_AccesorioID,
		Par_InstitNominaID,				Par_ConvenioID,					Par_TipoLista,				Aud_EmpresaID,				Aud_Usuario,
		Aud_FechaActual,				Aud_DireccionIP,				Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion
	);

END TerminaStore$$
