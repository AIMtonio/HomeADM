-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANPROMOTORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPROMOTORESLIS`;
DELIMITER $$


CREATE PROCEDURE `BANPROMOTORESLIS`(
-- ===================================================================
--				SP PARA LISTAR LOS TIPOS DE DOCUMENTOS
-- ===================================================================
	Par_Nombre			VARCHAR(60),		-- Parametro descripcion
	Par_SucursalID		INT(11),			-- Parametro de sucursal
	Par_TamanioLista	INT(11),			-- Parametro tamanio de la lista
	Par_PosicionInicial	INT(11),			-- Parametro posicion inicial de la lista
	Par_NumLis			TINYINT UNSIGNED,	-- Parametro Numero de lista

	-- Parametros de auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)

TerminaStore: BEGIN


	-- declaracion de constantes
	DECLARE	List_Principal		INT(11);
	DECLARE Cadena_Vacia		VARCHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE Letra_Est_Act		CHAR(1);
	DECLARE Letra_Est_Inact		CHAR(1);
	DECLARE Estatus_Activo		CHAR(6);
	DECLARE Estatus_Inactivo	CHAR(8);

	-- asignacion de constantes
	SET List_Principal		:= 1;	-- Constante lista principal
	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Letra_Est_Act		:= 'A';
	SET Letra_Est_Inact		:= 'I';
	SET Estatus_Activo		:= 'ACTIVO';
	SET Estatus_Inactivo	:= 'INACTIVO';

	SET Par_Nombre			:= IFNULL(Par_Nombre, Cadena_Vacia);
	SET Par_SucursalID		:= IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_PosicionInicial	:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_TamanioLista	:= IFNULL(Par_TamanioLista, Entero_Cero);

	IF (Par_TamanioLista = Entero_Cero) THEN
		SET Par_TamanioLista := (SELECT COUNT(*) FROM PROMOTORES);
	END IF;

	IF Par_NumLis=List_Principal THEN
		SELECT	P.PromotorID,	P.NombrePromotor,	P.NombreCoordinador, P.Telefono,	P.Celular,
				P.Correo,		P.NumeroEmpleado,	P.Estatus,
				IF(P.Estatus=Letra_Est_Act,
					Estatus_Activo,
					Estatus_Inactivo) AS DescripcionEstatus,
				S.SucursalID,	S.NombreSucurs AS NombreSucursal
			FROM PROMOTORES P
				INNER JOIN SUCURSALES S
						ON S.SucursalID = P.SucursalID
				WHERE	NombrePromotor  LIKE CONCAT("%", Par_Nombre, "%")
					AND	P.SucursalID = IF(Par_SucursalID > Entero_Cero, Par_SucursalID, P.SucursalID)
		LIMIT Par_PosicionInicial, Par_TamanioLista;
	END IF;

END TerminaStore$$