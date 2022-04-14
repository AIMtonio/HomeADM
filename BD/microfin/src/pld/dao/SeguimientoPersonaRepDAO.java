package pld.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.SeguimientoPersonaRepBean;
import pld.bean.SociosAltoRiesgoRepBean;
import general.dao.BaseDAO;

public class SeguimientoPersonaRepDAO extends BaseDAO{

	public SeguimientoPersonaRepDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Datos para reporte de Socios de Alto Riesgo //
	public List seguimientoPersonasRep( SeguimientoPersonaRepBean seguimientoPersonaRepBean,
											int tipoLista){	
		List ListaResultado=null;					
		try{
		String query = "call PLDSEGUIMIENTOPERSONAREP(?,?,?,?,  ?,?,?,?,?,?,?)";

		Object[] parametros ={
							seguimientoPersonaRepBean.getFechaInicio(),
							seguimientoPersonaRepBean.getFechaFin(),
							seguimientoPersonaRepBean.getOperaciones(),
							tipoLista,
						
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDSEGUIMIENTOPERSONAREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguimientoPersonaRepBean seguimientoPersonaRep= new SeguimientoPersonaRepBean();
				seguimientoPersonaRep.setFolio(resultSet.getString("Folio"));
				seguimientoPersonaRep.setNumcliente(resultSet.getString("NumCliente"));
				seguimientoPersonaRep.setNombreCliente(resultSet.getString("NombreCliente"));
				seguimientoPersonaRep.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
				seguimientoPersonaRep.setListaDeteccion(resultSet.getString("ListaDeteccion"));
				seguimientoPersonaRep.setActividadBMX(resultSet.getString("ActividadBMX"));
				seguimientoPersonaRep.setPermiteOperacion(resultSet.getString("PermiteOperacion"));
				seguimientoPersonaRep.setComentario(resultSet.getString("Comentario"));
				
				return seguimientoPersonaRep ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Informacion para el reporte", e);
		}
		return ListaResultado;
	}
	
}
