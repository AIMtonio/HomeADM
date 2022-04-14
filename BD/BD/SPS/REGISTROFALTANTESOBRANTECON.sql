-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGISTROFALTANTESOBRANTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGISTROFALTANTESOBRANTECON`;
DELIMITER $$


CREATE PROCEDURE `REGISTROFALTANTESOBRANTECON`(
# ==================================================================================================
# ---  CONSULTA LOS DATOS LA CAJA CON USUARIO SEAN CORRECTOS PARA AUTORIZAR SOLICITUD DE AJUSTE---
# ==================================================================================================
	Par_CajaID					INT(11),				-- ID de la caja
	Par_UsuarioCaja				INT(11),				-- ID del usuario de la caja la que hizo la solicitud
	Par_SoliID					INT(11),				-- ID de la solicitud de ajuste
	Par_TipoOperacion			CHAR(1),				-- Indica si es ajuste por faltante o por sobrante.F=Ajuste por Faltante, S=Ajuste por Sobrante.
	Par_MontoSol				DECIMAL(10,2),			-- Montos de la solicitud
	Par_UsuarioAutoriza			VARCHAR(50),			-- clave del usuario que autoriza
	Par_ContraUsuarioAu			VARCHAR(45),			-- Contraseña del usuario
	Par_NumCon					INT(11),				-- Numero de Validacion

	Aud_EmpresaID        		INT(11),				-- ID de la Empresa
	Aud_Usuario         	 	INT(11),				-- ID del usuario
	Aud_FechaActual      		DATETIME,				-- Fecha Actual
	Aud_DireccionIP      		VARCHAR(20),			-- Direccion IP
	Aud_ProgramaID       		VARCHAR(50),			-- ID del programa
	Aud_Sucursal         		INT(11),				-- ID de la sucursal
	Aud_NumTransaccion   		BIGINT(20)				-- Numero de transaccion
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);				-- Constante cadena vacia
	DECLARE	Fecha_Vacia			DATE;       			-- Constante fecha vacia
	DECLARE	Entero_Cero			INT(11);    			-- Constante entero cero
	DECLARE SalidaSI			CHAR(1);    			-- Constante salida si
	DECLARE Con_Principal			INT(11);    		-- Constante validacion principal
	DECLARE EstatusCerrada		CHAR(1);				-- Constante estatus cerrada
	DECLARE EstatusAutorizado	CHAR(1);				-- Constante estatus 

	-- Declaracion de Variables
	DECLARE Var_CajaID			INT(11);				-- Variable caja id
	DECLARE Var_EstatusOpera	CHAR(1);				-- Variable estatus operacion
	DECLARE Var_EstatusSol		CHAR(1);				-- Variable estatus solicitud ajuste
	DECLARE Var_NumCaja			INT(11);				-- Numero de la caja en la solicitud de ajuste
	DECLARE Var_UsuarioID		INT(11);				-- Variable id del usuario
	
	-- Asignacion de Constantes
	SET	Cadena_Vacia 			:= '';					-- Constante Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';		-- Constante Fecha Vacia
	SET	Entero_Cero				:= 0;					-- Constante Entero Cero
	SET SalidaSI				:= 'S';					-- Constante Salida SI
	SET Con_Principal			:= 1;					-- Constante para consulta principal
	SET EstatusCerrada			:='C';					-- Estatus cerrada
	SET EstatusAutorizado		:= 'A';					-- Estatus de la solicitud autorizado

	IF(Par_NumCon = Con_Principal)THEN
		-- Se consulta si existe alguna solicitud con el numero de caja y tipo de solicitud
		SELECT  NumCaja,		Estatus,			RegFaltanteSobranteID
		FROM REGISTROFALTANTESOBRANTE
		WHERE NumCaja = Par_CajaID
		AND TipoOperacion = Par_TipoOperacion
		AND UsuarioAutoriza = Par_UsuarioAutoriza
		AND Monto = Par_MontoSol
		AND Estatus	!= EstatusAutorizado
		LIMIT 1;

	END IF;

END TerminaStore$$
