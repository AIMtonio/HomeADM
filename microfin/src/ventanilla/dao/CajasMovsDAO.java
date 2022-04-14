package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;

import ventanilla.bean.CajasMovsBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CajasMovsDAO extends BaseDAO{

	
	
	public List listaReporteCajaPrincipal(CajasMovsBean cajasMovsBean, int tipoLista){	
		List ListaResultado=null;
		try{
		String query = "call CAJAPRINCIPALREP(?,?,?,?,?,  ?,?,?,?,?, ?)";

		Object[] parametros ={
							Utileria.convierteFecha(cajasMovsBean.getFechaInicio()),
							Utileria.convierteFecha(cajasMovsBean.getFechaFin()),
							Utileria.convierteEntero(cajasMovsBean.getCajaID()),
							Utileria.convierteEntero(cajasMovsBean.getMonedaID()),							
				    		
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};
		
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJAPRINCIPALREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CajasMovsBean cajasMovs= new CajasMovsBean();
				
				cajasMovs.setCajaID(resultSet.getString("CajaID"));

				cajasMovs.setNombreCaja(resultSet.getString("NombreCaja"));
				cajasMovs.setFecha(resultSet.getString("Fecha"));				
				cajasMovs.setTransaccion(resultSet.getString("Transaccion"));
				cajasMovs.setTipo(resultSet.getString("Tipo"));
				
				
				cajasMovs.setDescripcion(resultSet.getString("Descripcion"));
				cajasMovs.setReferencia(resultSet.getString("Referencia"));
				cajasMovs.setReferencia2(resultSet.getString("Referencia2"));
				cajasMovs.setEntradas(resultSet.getString("Entrada"));
				cajasMovs.setSalidas(resultSet.getString("Salida"));
				cajasMovs.setHoraHemision(resultSet.getString("HoraEmision"));
				
				
				
				return cajasMovs ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reprte de Creditos Castigados", e);
		}
		return ListaResultado;
	}
}
