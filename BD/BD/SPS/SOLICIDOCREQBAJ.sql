-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCREQBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICIDOCREQBAJ`;
DELIMITER $$

CREATE PROCEDURE `SOLICIDOCREQBAJ`(
	Par_ProducCreID      	INT,

	Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT,
	INOUT Par_ErrMen    	VARCHAR(400),
	Par_EmpresaID        	INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal		   	INT,
	Aud_NumTransaccion  	BIGINT
	)
TerminaStore: BEGIN


DECLARE Var_SolDocRID		INT;
DECLARE Var_Estatus			CHAR(2);		-- Almacena el estatus del producto de credito
DECLARE Var_Descripcion		VARCHAR(100);	-- Almacena la descripcion del producto de credito

DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Fecha_Vacia   	DATE;
DECLARE SalidaNO		CHAR(1);
DECLARE SalidaSI		CHAR(1);
DECLARE Estatus_Inactivo	CHAR(1);	-- Estatus Inactivo



SET Entero_Cero		:=0;
SET Decimal_Cero	:=0.0;
SET Cadena_Vacia	:='';
SET Fecha_Vacia		:= '1900-01-01';
SET SalidaNO		:= 'N';
SET SalidaSI		:= 'S';
SET Estatus_Inactivo	:= 'I';		 -- Estatus Inactivo


SELECT 	Estatus,		Descripcion
INTO 	Var_Estatus,	Var_Descripcion
FROM PRODUCTOSCREDITO
WHERE ProducCreditoID = Par_ProducCreID;

IF(Var_Estatus = Estatus_Inactivo) THEN
	SELECT '001' AS NumErr,
	CONCAT('El Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.') AS ErrMen,
	'producCreditoID' AS control,
     Par_ProducCreID AS consecutivo;
	 LEAVE TerminaStore;
END IF;

DELETE FROM SOLICIDOCREQ
	WHERE ProducCreditoID = Par_ProducCreID;

IF(Par_Salida =SalidaSI) THEN
    SELECT '000' AS NumErr,
            CONCAT("Los Documentos Requeridos para el Producto: ",
			CONVERT(Par_ProducCreID, CHAR)," Fueron Eliminados.")  AS ErrMen,
            'producCreditoID' AS control,
            Par_ProducCreID AS consecutivo;
END IF;

IF(Par_Salida =SalidaNO) THEN
        SET 	Par_NumErr := 0;
        SET	Par_ErrMen :=  CONCAT("Los Documentos Requeridos para el Producto : ",
							CONVERT(ProducCreditoID, CHAR)," Fueron Eliminados.");
        LEAVE TerminaStore;
END IF;

END TerminaStore$$