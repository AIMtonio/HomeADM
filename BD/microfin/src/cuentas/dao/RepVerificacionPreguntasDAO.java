package cuentas.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import general.dao.BaseDAO;
import herramientas.Utileria;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import cuentas.bean.RepVerificacionPreguntasBean;

public class RepVerificacionPreguntasDAO extends BaseDAO{
	
	public RepVerificacionPreguntasDAO (){
		super();
	}

	// Reporte Verificacion de Preguntas en Excel
	public List <RepVerificacionPreguntasBean> reporteVerificacionPreguntas(int tipoLista,RepVerificacionPreguntasBean repVerificacionPreguntasBean){
		List listaVerificacionPreguntas = null;
		try{
		
			String query = "call VERIFICAPREGUNTASSEGREP(?,?,?,?,?,  ?,?,?,?,?,	?);";
			Object[] parametros = {	
					
					repVerificacionPreguntasBean.getFechaInicio(),
					repVerificacionPreguntasBean.getFechaFin(),
					Utileria.convierteEntero(repVerificacionPreguntasBean.getClienteID()),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RepVerificacionPreguntasDAO.verificacionPreguntas",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VERIFICAPREGUNTASSEGREP(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepVerificacionPreguntasBean bean = new RepVerificacionPreguntasBean();
					
					bean.setClienteID(resultSet.getString("ClienteID"));
					bean.setNombreCliente(resultSet.getString("NombreCliente"));
					bean.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
					bean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					bean.setFecha(resultSet.getString("Fecha"));
					
					bean.setHora(resultSet.getString("Hora"));
					bean.setTipoSoporte(resultSet.getString("TipoSoporte"));
					bean.setUsuario(resultSet.getString("Usuario"));
					bean.setResultado(resultSet.getString("Resultado"));
			
			return bean;
				}
			});
			listaVerificacionPreguntas = matches; 
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al generar reporte Verificación de Preguntas " + e);
		}
		return listaVerificacionPreguntas;
	}
}
