-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CICLOBASECLIPROMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CICLOBASECLIPROMOD`;DELIMITER $$

CREATE PROCEDURE `CICLOBASECLIPROMOD`(
    Par_Cliente				INT,
    Par_Prospecto   		INT,
    Par_Producto          	INT,
    Par_CicloBase       	INT,

    Par_EmpresaID       	INT,

    Aud_Usuario         	INT,
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
    Aud_NumTransaccion  	BIGINT
)
TerminaStore: BEGIN


DECLARE Var_Estatus			CHAR(1);


DECLARE	Estatus_Activo		CHAR(1);
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Inactivo			CHAR(1);


SET	Estatus_Activo			:= 'A';
SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET Aud_FechaActual 		:= CURRENT_TIMESTAMP();
SET Inactivo				:='I';

	IF(IFNULL(Par_Cliente, Entero_Cero)) = Entero_Cero	THEN
		IF (IFNULL(Par_Prospecto, Entero_Cero)) = Entero_Cero THEN
			SELECT '002' AS NumErr,
				 'El alta de Ciclo Base Inicial necesita al menos el Cliente o el Prospecto.' AS ErrMen,
				 'ClienteProspecto' AS control,
				'0' AS consecutivo;
			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(Par_Cliente>Entero_Cero)THEN
		SELECT Estatus INTO Var_Estatus
			FROM CLIENTES
				WHERE ClienteID=Par_Cliente;
		IF(Var_Estatus=Inactivo)THEN
			SELECT '003' AS NumErr,
			 'El Cliente Indicado se encuentra Inactivo.' AS ErrMen,
			 'clienteID' AS control,
			  '0' AS consecutivo;
		LEAVE TerminaStore;
		END IF;
	END IF;

	IF(IFNULL(Par_Producto, Entero_Cero)) = Entero_Cero THEN
		SELECT '003' AS NumErr,
			 'El Producto de Credito esta vacio.' AS ErrMen,
			 'productocCreditoID' AS control,
			  '0' AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_CicloBase, Entero_Cero)) = Entero_Cero THEN
		SELECT '004' AS NumErr,
			  'El Ciclo Base Inicial esta Vacio.' AS ErrMen,
			  'CicloBaseInicial' AS control,
			   '0' AS consecutivo;
		LEAVE TerminaStore;
	END IF;


	UPDATE CICLOBASECLIPRO SET
		ProductoCreditoID	=	Par_Producto,
		CicloBase			=	Par_CicloBase,
		EmpresaID			=	Par_EmpresaID,
		Usuario				=	Aud_Usuario,
		FechaActual			=	Aud_FechaActual,
		DireccionIP			=	Aud_DireccionIP,
		ProgramaID			=	Aud_ProgramaID,
		Sucursal			=	Aud_Sucursal,
		NumTransaccion		=	Aud_NumTransaccion
	WHERE ClienteID = Par_Cliente
	AND ProspectoID=Par_Prospecto
	AND ProductoCreditoID = Par_Producto;

	SELECT '000' AS NumErr,
	'El Ciclo Base Inicial Modificado.' AS ErrMen,
	'CicloBaseInicial' AS control,
	'0' AS consecutivo;

END TerminaStore$$