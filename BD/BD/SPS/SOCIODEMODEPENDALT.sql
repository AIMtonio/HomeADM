-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMODEPENDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMODEPENDALT`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMODEPENDALT`(

	Par_ProspectoID			int(11),
	Par_ClienteID			int(11),
	Par_FechaRegistro		date ,
	Par_TipoRelacionID		int(11) ,
	Par_PrimerNombre		varchar(25) ,
	Par_SegundoNombre		varchar(25) ,
	Par_TercerNombre		varchar(25) ,
	Par_ApellidoPaterno		varchar(30) ,
	Par_ApellidoMaterno		varchar(30) ,

	Par_Edad				INT(11) ,			-- Edad del dependiente economico
	Par_OcupacionID			INT(11) ,			-- Identificador de la ocupacion

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Aud_Empresa             int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_DescriProd          char(150);
DECLARE Var_DescriPues          char(150);
DECLARE Var_ProspectoID         int(11);
DECLARE Var_ClienteID           int(11);
DECLARE Var_TipoRelacionID      INT(11);
DECLARE Var_DependienteID       int(11);
-- Agregado de variables nuevas que corresponden a parametro OcupacionID. Cardinal Sistemas Inteligentes
	DECLARE Var_OcupacionID		INT(11);
-- Fin de agregado de variables nuevas. Cardinal Sistemas Inteligentes

-- Declaracion de constantes
DECLARE Cadena_Vacia            char(1);
DECLARE Entero_Cero             int;
DECLARE SalidaNO                char(1);
DECLARE SalidaSI                char(1);

-- Asignacion  de constantes
Set Cadena_Vacia            := '';
Set Entero_Cero             := 0;           -- Entero en Cero
Set SalidaNO                :='N';          -- El store NO arroja una SALIDA
Set SalidaSI                :='S';          -- El store SI arroja una SALIDA

-- Fecha de Base de Datos
Set Aud_FechaActual         := CURRENT_TIMESTAMP();

/* Inicializar parametros de salida */
Set Par_NumErr              := 1;
set Par_ErrMen              := Cadena_Vacia;

Set Par_FechaRegistro       :=	(select FechaSistema from PARAMETROSSIS);

if(ifnull(Par_ProspectoID, Entero_Cero)) = Entero_Cero then
	Set Par_ProspectoID := Entero_Cero;
end if;


if(ifnull(Par_ClienteID, Entero_Cero)) = Entero_Cero then
	Set Par_ClienteID := Entero_Cero;
end if;


if (Par_ProspectoID = Entero_Cero and Par_ClienteID = Entero_Cero) then
    Set Par_ErrMen  := 'Debe seleccionar un Cliente o Prospecto.';
    if(Par_Salida = SalidaSI) then
			select '001' as NumErr,
				Par_ErrMen as ErrMen,
				'clienteID' as control,
             Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

-- valida que cliente o Prospecto exista
if Par_ClienteID > Entero_Cero then
    if not exists(select ClienteID from CLIENTES where ClienteID = Par_ClienteID) then
        Set Par_ErrMen  := 'El Numero de Cliente no Existe';
        if(Par_Salida = SalidaSI) then
                select '002' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
else
    if not exists(select ProspectoID from PROSPECTOS where ProspectoID = Par_ProspectoID) then
        Set Par_ErrMen  := 'El Numero de Prospecto no Existe';
        if(Par_Salida = SalidaSI) then
                select '003' as NumErr,
                        Par_ErrMen as ErrMen,
                        'prospectoID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
end if;


if not exists(select TipoRelacionID from TIPORELACIONES where TipoRelacionID = Par_TipoRelacionID) then
    Set Par_ErrMen  := 'EL Tipo de Relacion Indicado no Existe.';
    if(Par_Salida = SalidaSI) then
            select '004' as NumErr,
                    Par_ErrMen as ErrMen,
                    'prospectoID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if CHAR_LENGTH(Par_PrimerNombre) <= Entero_Cero then
    Set Par_ErrMen  := 'El Primero Nombre del Dependiente Economico esta Vacio';
    if(Par_Salida = SalidaSI) then
            select '005' as NumErr,
                    Par_ErrMen as ErrMen,
                    'clienteID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if CHAR_LENGTH(Par_ApellidoPaterno) <= Entero_Cero then
    Set Par_ErrMen  := 'El Apellido Paterno del Dependiente Economico esta Vacio';
    if(Par_Salida = SalidaSI) then
            select '006' as NumErr,
                    Par_ErrMen as ErrMen,
                    'clienteID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if CHAR_LENGTH(Par_ApellidoMaterno) <= Entero_Cero then
    Set Par_ErrMen  := 'El Apellido Materno del Dependiente Economico esta Vacio';
    if(Par_Salida = SalidaSI) then
            select '007' as NumErr,
                    Par_ErrMen as ErrMen,
                    'clienteID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;
		-- Validaciones para los parametros nuevos de la tabla SOCIODEMODEPEND. Cardinal Sistemas Inteligentes
		SET Par_Edad	:= IFNULL(Par_Edad, Entero_Cero);

		IF(Par_Edad <= Entero_Cero) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= 'La edad no puede ser menor o igual que cero.';
			SELECT	Par_NumErr as NumErr,
					Par_ErrMen as ErrMen,
					'clienteID' as control,
					Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		END IF;
		-- Se valida el ID de la ocupacion
		SELECT OcupacionID INTO Var_OcupacionID
			FROM OCUPACIONES
			WHERE OcupacionID = Par_OcupacionID;

		SET Var_OcupacionID	:= IFNULL(Var_OcupacionID,Entero_Cero);

		IF(Var_OcupacionID = Entero_Cero) THEN
			SET Par_NumErr	:= 009;
			SET Par_ErrMen	:= 'La ocupacion especificada no se encuentra en la base de datos.';
			SELECT	Par_NumErr as NumErr,
					Par_ErrMen as ErrMen,
					'clienteID' as control,
					Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		END IF;
		-- Termina la validacion
		-- Fin de validaciones para los parametros nuevos. Cardinal Sistemas Inteligentes

-- Generar ID
Set Var_DependienteID   := (select ifnull(max(DependienteID), Entero_Cero) from SOCIODEMODEPEND);

Set Var_DependienteID   := ifnull(Var_DependienteID, Entero_Cero) + 1 ;
-- Modificacion al alta para agregar nuevos campos de ocupacion y edad. Cardinal Sistemas Inteligentes
		INSERT INTO SOCIODEMODEPEND (	DependienteID,			ProspectoID,			ClienteID,			FechaRegistro,			TipoRelacionID,
										PrimerNombre,			SegundoNombre,			TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
										Edad,					OcupacionID,			EmpresaID,			Usuario,				FechaActual,
										DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion
			)
			VALUES(						Var_DependienteID,		Par_ProspectoID,		Par_ClienteID,		Par_FechaRegistro,		Par_TipoRelacionID,
										Par_PrimerNombre,		Par_SegundoNombre,		Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
										Par_Edad,				Par_OcupacionID,		Aud_Empresa,		Aud_Usuario,			Aud_FechaActual,
										Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
-- Fin de modificacion al alta. Cardinal Sistemas Inteligentes


Set Par_NumErr  := Entero_Cero;
Set Par_ErrMen  := 'Dependiente Economico Agregado con Exito';

if(Par_Salida = SalidaSI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'antiguedadLab' as control,
                Entero_Cero as consecutivo;
end if;



END TerminaStore$$