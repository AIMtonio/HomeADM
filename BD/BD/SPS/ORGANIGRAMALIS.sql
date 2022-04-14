-- ORGANIGRAMALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANIGRAMALIS`;
DELIMITER $$

CREATE PROCEDURE `ORGANIGRAMALIS`(
-- =====================================================================================
-- ------- STORED PARA LISTA DE DEPENDENCIAS EN EL ORGANIGRAMA ---------
-- =====================================================================================
	Par_PuestoPadreID		BIGINT,			-- ID de empleado que tiene puesto padre
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Principal	INT(11);    
    DECLARE Est_Activo		CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
    SET Est_Activo			:= 'A';

	-- 1.- Lista para grid dependencias en pantalla organigrama
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT 	O.PuestoHijoID, 	P.Descripcion, 		E.NombreCompleto, O.RequiereCtaCon, O.CtaContable,
				O.CentroCostoID,	CTA.DescriCorta AS DescripcionCtaCon,	CEN.Descripcion AS DescripcionCenCos
		FROM EMPLEADOS E
			INNER JOIN PUESTOS P 
				ON E.ClavePuestoID= P.ClavePuestoID
			INNER JOIN ORGANIGRAMA O 
				ON E.EmpleadoID= O.PuestoHijoID
			LEFT JOIN CUENTASCONTABLES CTA
				ON O.CtaContable = CTA.CuentaCompleta
			LEFT JOIN CENTROCOSTOS CEN
				ON O.CentroCostoID = CEN.CentroCostoID
		WHERE O.PuestoPadreID = Par_PuestoPadreID
			AND E.Estatus = Est_Activo;
	END IF;

END TerminaStore$$