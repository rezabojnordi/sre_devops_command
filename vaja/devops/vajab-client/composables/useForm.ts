import { ExtractPropTypes } from 'vue'

export const useFormProps = {
  disabled: { type: Boolean, default: false },
  readonly: { type: Boolean, default: false },
}

export const useFormPropsWithId = {
  ...useFormProps,
  id: { type: [String, Number], default: undefined },
  name: { type: [String, Number], default: undefined },
}

/**
 * @description creates `readonly` and `disabled` BEM modifiers.
 * @param prefix string that classes start with (base BEM class).
 * @param props component props.
 * @returns computed classes object starting with `prefix` and ending with form state BEM modifier.
 */
export const useForm = <Prefix extends string = ''>(
  prefix: Prefix,
  props: ExtractPropTypes<typeof useFormProps>
) => {
  const computedClasses = useBem<'disabled' | 'readonly', Prefix>(
    prefix,
    computed(() => reactivePick(props, 'disabled', 'readonly'))
  )
  return { computedClasses }
}
