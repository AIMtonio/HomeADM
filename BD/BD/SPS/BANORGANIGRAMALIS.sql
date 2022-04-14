-- BANORGANIGRAMALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANORGANIGRAMALIS`;
DELIMITER $$

CREATE PROCEDURE `BANORGANIGRAMALIS`(
-- =====================================================================================
-- ------- STORED PARA LISTA DE DEPENDENCIAS EN EL ORGANIGRAMA ---------
-- =====================================================================================
	Par_PuestoPadreID		BIGINT(20),			-- ID de empleado que tiene puesto padre
	Par_PuestoHijoID		BIGINT(20),			-- ID de empleado que tiene el puesto Hijo
	Par_TamanioLista		INT(11),			-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),			-- Parametro posicion inicial de la lista

	Par_NumLis				TINYINT UNSIGNED,	-- Numero de lista

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);			-- Constante de Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;				-- Constante de Fecha Vacia
	DECLARE	Entero_Cero		INT(11);			-- Constante de Entero Cero

	DECLARE	Lis_Principal	INT(11);			-- Lista de las organigrama para el WS de Milagro

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		:= '';				-- Constante de Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Constante de Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Constante de Entero Cero

	SET	Lis_Principal		:= 1;				-- Lista de las organigrama para el WS de Milagro

	-- 1.- Lista de las organigrama para el WS de Milagro
	IF(Par_NumLis = Lis_Principal) THEN

		DELETE FROM TMP_BANORGANIGRAMA WHERE NumTransaccion = Aud_NumTransaccion;

		INSERT INTO TMP_BANORGANIGRAMA(	PuestoPadreID,		NomCompletoPadre,	ClaveUsuarioPadre,	PadreEsGestor,		PadreEsSupervisor,
									PuestoHijoID,		NomCompletoHijo,	ClaveUsuarioHijo,	HijoEsGestor,		HijoEsSupervisor,
									RequiereCtaCon,		CtaContable,		CentroCostoID,		ClavePuestoPadre,	ClavePuestoHijo,
									NumTransaccion
			)
			SELECT					ORG.PuestoPadreID,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
									ORG.PuestoHijoID,	EMP.NombreCompleto,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
									ORG.RequiereCtaCon,	ORG.CtaContable,	ORG.CentroCostoID,	Cadena_Vacia,		EMP.ClavePuestoID,
									Aud_NumTransaccion
				FROM ORGANIGRAMA ORG
				INNER JOIN EMPLEADOS EMP ON EMP.EmpleadoID = ORG.PuestoHijoID;

		UPDATE TMP_BANORGANIGRAMA TMP
			INNER JOIN EMPLEADOS EMP ON EMP.EmpleadoID = TMP.PuestoPadreID AND TMP.NumTransaccion = Aud_NumTransaccion
			SET TMP.NomCompletoPadre = EMP.NombreCompleto,
				TMP.ClavePuestoPadre = EMP.ClavePuestoID;
		
		UPDATE TMP_BANORGANIGRAMA TMP
			INNER JOIN USUARIOS USU ON USU.EmpleadoID = TMP.PuestoPadreID AND TMP.NumTransaccion = Aud_NumTransaccion
			SET	TMP.ClaveUsuarioPadre = USU.Clave;

		UPDATE TMP_BANORGANIGRAMA TMP
			INNER JOIN PUESTOS PUE ON PUE.ClavePuestoID = TMP.ClavePuestoPadre AND TMP.NumTransaccion = Aud_NumTransaccion
			SET	TMP.PadreEsGestor = PUE.EsGestor,
				TMP.PadreEsSupervisor = PUE.EsSupervisor;

		UPDATE TMP_BANORGANIGRAMA TMP
			INNER JOIN USUARIOS USU ON USU.EmpleadoID = TMP.PuestoHijoID AND TMP.NumTransaccion = Aud_NumTransaccion
			SET	TMP.ClaveUsuarioHijo = USU.Clave;

		UPDATE TMP_BANORGANIGRAMA TMP
			INNER JOIN PUESTOS PUE ON PUE.ClavePuestoID = TMP.ClavePuestoHijo AND TMP.NumTransaccion = Aud_NumTransaccion
			SET	TMP.HijoEsGestor = PUE.EsGestor,
				TMP.HijoEsSupervisor = PUE.EsSupervisor;

		IF(Par_TamanioLista = Entero_Cero) THEN
			SELECT COUNT(PuestoPadreID)
				INTO Par_TamanioLista
				FROM TMP_BANORGANIGRAMA;
		END IF;

		SELECT	PuestoPadreID,		NomCompletoPadre,	ClaveUsuarioPadre,	PadreEsGestor,	PadreEsSupervisor,
				PuestoHijoID,		NomCompletoHijo,	ClaveUsuarioHijo,	HijoEsGestor,	HijoEsSupervisor,
				RequiereCtaCon,		CtaContable,		CentroCostoID
			FROM TMP_BANORGANIGRAMA
			WHERE PuestoPadreID = IF(Par_PuestoPadreID > Entero_Cero, Par_PuestoPadreID, PuestoPadreID)
			AND PuestoHijoID = IF(Par_PuestoHijoID > Entero_Cero, Par_PuestoHijoID, PuestoHijoID)
			AND NumTransaccion = Aud_NumTransaccion
			LIMIT Par_PosicionInicial, Par_TamanioLista;

		DELETE FROM TMP_BANORGANIGRAMA WHERE NumTransaccion = Aud_NumTransaccion;
	END IF;

END TerminaStore$$
