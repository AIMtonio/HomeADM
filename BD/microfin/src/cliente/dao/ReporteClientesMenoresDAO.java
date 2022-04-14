package cliente.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.RepoteClientesMenoresBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ReporteClientesMenoresDAO extends BaseDAO{
	
	public List<RepoteClientesMenoresBean> consultaSociosMenores(
			RepoteClientesMenoresBean repoteClientesMenoresBean) {
		// TODO Auto-generated method stub
		List listaResultado = null;
		
		try{
		String query = "call SOCIOMENORREP(?,?,?,?,?  ,?,?,?,?,? )";
		
		Object[] parametros ={
				Utileria.convierteEntero(repoteClientesMenoresBean.getSucursalID()),
				repoteClientesMenoresBean.getEstatusCta(),
				Utileria.convierteEntero(repoteClientesMenoresBean.getPromotorActual()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ReporteClientesMenoresDAO.consultaSociosMenores",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOCIOMENORREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepoteClientesMenoresBean clientesMenoresBean= new RepoteClientesMenoresBean();
								
				clientesMenoresBean.setNoSocioMenor(String.valueOf(resultSet.getInt("NoSocioMenor")));
				clientesMenoresBean.setNombreSocioMenor(resultSet.getString("NombreClienteMenor"));
				clientesMenoresBean.setDirecSocioMenor(resultSet.getString("DirecSocioMenor"));				
				clientesMenoresBean.setEdad(String.valueOf(resultSet.getInt("Edad")));
				clientesMenoresBean.setFechaNacimiento(String.valueOf(resultSet.getDate("FechaNacimiento")));
				clientesMenoresBean.setClienteTutorID(String.valueOf(resultSet.getInt("ClienteTutorID")));
				clientesMenoresBean.setNombreTutor(resultSet.getString("NombreTutor"));
				clientesMenoresBean.setNombreTutorSocMe(resultSet.getString("nombreTutorSocMe"));
				clientesMenoresBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				clientesMenoresBean.setEstatusCta(resultSet.getString("Estatus"));				
				clientesMenoresBean.setSaldo(String.valueOf(resultSet.getDouble("Saldo")));
				clientesMenoresBean.setPromotorActual(String.valueOf(resultSet.getInt("PromotorActual")));
				clientesMenoresBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
				clientesMenoresBean.setSucursalID(String.valueOf(resultSet.getInt("SucursalOrigen")));
				clientesMenoresBean.setNombreSucurs(resultSet.getString("NombreSucursal"));
				

				return clientesMenoresBean ;
			}
		});
		listaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de Socio Menor", e);
		}
		return listaResultado;
	}

}
