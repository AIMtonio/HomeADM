package soporte.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import soporte.bean.CalculoDiaFestivoBean;

public class DiaFestivoDAO extends BaseDAO{

	
	public DiaFestivoDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	/* Calculo y Validacion de Dia Festivo o Habil */
	public CalculoDiaFestivoBean calculaDiaFestivoSiguiente(CalculoDiaFestivoBean diaFestivoBean) {
		CalculoDiaFestivoBean diaFesBean = new CalculoDiaFestivoBean();
		try{
			//Query con el Store Procedure
			String query = "call DIASFESTIVOSPANCAL(?,?,?,?,?,?,?,?,?,?);";		
			Object[] parametros = {
								 	diaFestivoBean.getFecha(),
								 	diaFestivoBean.getNumeroDias(),
								 	diaFestivoBean.getSigAnt(),
								 	Constantes.ENTERO_CERO,
								 	
								 	Constantes.ENTERO_CERO,
								 	Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DiaFestivoDAO.calculaDiaFestivo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIASFESTIVOSPANCAL(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CalculoDiaFestivoBean festivoBean = new CalculoDiaFestivoBean();
						festivoBean.setFecha(resultSet.getString(1));			
						festivoBean.setNumeroDias(resultSet.getInt(2));
						festivoBean.setEsFechaHabil(resultSet.getString(3));
						
						return festivoBean;
		
				}
			});
					
			diaFesBean= matches.size() > 0 ? (CalculoDiaFestivoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en calcular dias festivos", e);
		}
		return diaFesBean;
		
	}
	/**
	 * M??todo que llama a la funci??n que le suma d??as a una fecha. Antes de sumar a la fecha el n??mero de d??as,
	 * valida que la fecha sea v??lida, sino es v??lida regresa el valor de fecha vac??a [1900-01-01].
	 * @param diaFestivoBean : Clase bean con los valores de entrada a la funci??n FN-FNSUMADIASFECHA.
	 * @return {@link CalculoDiaFestivoBean} con la fecha como resultado.
	 * @author avelasco
	 */
	public CalculoDiaFestivoBean sumaDiasFecha(CalculoDiaFestivoBean diaFestivoBean) {
		CalculoDiaFestivoBean diaFesBean = new CalculoDiaFestivoBean();
		if(Utileria.esFecha(diaFestivoBean.getFecha())){
			try{
				String query = "select FNSUMADIASFECHA(?,?);";		
				Object[] parametros = {
						Utileria.convierteFecha(diaFestivoBean.getFecha()),
						diaFestivoBean.getNumeroDiasSuma()
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"select FNSUMADIASFECHA(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CalculoDiaFestivoBean festivoBean = new CalculoDiaFestivoBean();
						festivoBean.setFecha(resultSet.getString(1));
						return festivoBean;
					}
				});

				diaFesBean = matches.size() > 0 ? (CalculoDiaFestivoBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al sumar d??as a una fecha: ", e);
			}
		} else {
			diaFesBean.setFecha(Constantes.FECHA_VACIA);
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error: La Fecha \""+diaFestivoBean.getFecha()+"\" No es V??lida.");
		}
		return diaFesBean;
	}
	/**
	 * M??todo que suma d??as a una fecha y calcula la fecha h??bil siguiente o anterior.
	 * @param diaFestivoBean : Clase bean con los valores de entrada a la funci??n FN-FNSUMADIASFECHA y al SP-DIASFESTIVOSPANCAL.
	 * @return {@link CalculoDiaFestivoBean} con el resultado del c??lculo.
	 * @author avelasco
	 */
	public CalculoDiaFestivoBean sumaDiasFechaHabil(CalculoDiaFestivoBean diaFestivoBean) {
		CalculoDiaFestivoBean diaFesBean = new CalculoDiaFestivoBean();
		// Primero se realiza la suma de d??as a la fecha que llega desde pantalla.
		diaFesBean = sumaDiasFecha(diaFestivoBean);
		// Si la funci??n regresa una fecha vac??a ya no calcula el d??a h??bil. 
		if(diaFesBean.getFecha().equalsIgnoreCase(Constantes.FECHA_VACIA)){
			return diaFesBean;
		}
		// Despu??s se calcula el d??a h??bil (siguiente o anterior) de la fecha a la que se le sumaron los d??as.
		diaFestivoBean.setFecha(diaFesBean.getFecha());
		diaFesBean = calculaDiaFestivoSiguiente(diaFestivoBean);
		
		return diaFesBean;
	}
	
	/**
	 * Suma meses a una Fecha
	 * @param diaFestivoBean: {@link CalculoDiaFestivoBean}
	 * @return {@link CalculoDiaFestivoBean}
	 */
	public CalculoDiaFestivoBean sumaMesesFecha(CalculoDiaFestivoBean diaFestivoBean) {
		CalculoDiaFestivoBean diaFesBean = new CalculoDiaFestivoBean();
		if(Utileria.esFecha(diaFestivoBean.getFecha())){
			try{
				String query = "select FNSUMMESESFECHA(?,?);";		
				Object[] parametros = {
						Utileria.convierteFecha(diaFestivoBean.getFecha()),
						diaFestivoBean.getNumeroMesesSuma()
				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"select FNSUMADIASFECHA(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CalculoDiaFestivoBean festivoBean = new CalculoDiaFestivoBean();
						festivoBean.setFecha(resultSet.getString(1));
						return festivoBean;
					}
				});

				diaFesBean = matches.size() > 0 ? (CalculoDiaFestivoBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al sumar meses a una fecha: ", e);
			}
		} else {
			diaFesBean.setFecha(Constantes.FECHA_VACIA);
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error: La Fecha \""+diaFestivoBean.getFecha()+"\" No es V??lida.");
		}
		return diaFesBean;
	}
}
